// lib/services/sync_service.dart

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quil/loacaldb/notemodel.dart';

class SyncService {
  static final _client = Supabase.instance.client;

  /// Opens the same DB that Dbhelper uses.
  /// Dbhelper._getdb() is private so we replicate its path logic here.
  static Future<Database> _db() async {
    return openDatabase(join(await getDatabasesPath(), 'notes.db'));
  }

  // ─── PUBLIC ENTRY POINT ──────────────────────────────────────────────────────

  /// Called once on startup after auth is confirmed. Never awaited by UI.
  /// Both syncs run in parallel since they touch separate tables.
  static Future<void> syncAll(String userId) async {
    await Future.wait([_syncNotes(userId), _syncTasks(userId)]);
  }

  // ─── NOTES ───────────────────────────────────────────────────────────────────

  static Future<void> _syncNotes(String userId) async {
    try {
      await _pushNotes(userId);
      await _pullNotes(userId);
    } catch (e) {
      // Best-effort — being offline is not an error
      debugPrint('[Sync] Notes error: $e');
    }
  }

  /// Push all local notes where isSynced = 0.
  /// Uses Note.fromMap() to deserialise from the NOTES table, matching the
  /// exact schema in Dbhelper: id, userId, title, content, summary,
  /// importance, created, updated, deletedat, isSynced, isarchived.
  static Future<void> _pushNotes(String userId) async {
    final db = await _db();

    final maps = await db.query(
      'NOTES',
      where: 'userId = ? AND isSynced = 0',
      whereArgs: [userId],
    );

    if (maps.isEmpty) return;

    for (final map in maps) {
      final note = Note.fromMap(map);
      try {
        // Supabase table uses snake_case; we map explicitly so a rename
        // in the model never silently breaks sync.
        await _client.from('notes').upsert({
          'id': note.id,
          'user_id': note.userId,
          'title': note.title,
          'content': note.content,
          'summary': note.summary,
          'importance': note.importance,
          'created': note.created.toIso8601String(),
          'updated': note.updated.toIso8601String(),
          'deletedat': note.deletedat?.toIso8601String(),
          'isarchived': note.isarchived?.toIso8601String(),
        });

        // Only mark synced after a confirmed successful push
        await db.update(
          'NOTES',
          {'isSynced': 1},
          where: 'id = ? AND userId = ?',
          whereArgs: [note.id, note.userId],
        );
      } catch (e) {
        // Leave isSynced = 0 so it retries on next startup
        debugPrint('[Sync] Failed to push note ${note.id}: $e');
      }
    }
  }

  /// Pull remote notes updated after our local watermark.
  /// Watermark = MAX(updated) among isSynced = 1 rows so we don't use our
  /// own pending (isSynced = 0) rows as the watermark and miss remote data.
  static Future<void> _pullNotes(String userId) async {
    final db = await _db();

    final wResult = await db.rawQuery(
      'SELECT MAX(updated) as w FROM NOTES WHERE userId = ? AND isSynced = 1',
      [userId],
    );
    final watermark = wResult.first['w'] as String?;

    final List<dynamic> remote = watermark != null
        ? await _client
              .from('notes')
              .select()
              .eq('user_id', userId)
              .gt('updated', watermark)
        : await _client.from('notes').select().eq('user_id', userId);

    for (final row in remote) {
      final remoteUpdated = DateTime.parse(row['updated'] as String);

      final existing = await db.query(
        'NOTES',
        where: 'id = ?',
        whereArgs: [row['id']],
        limit: 1,
      );

      if (existing.isEmpty) {
        // Note exists on server but not locally (created on another device).
        // Insert it, marked synced — local DB is now the source of truth for it.
        await db.insert('NOTES', {
          'id': row['id'],
          'userId': row['user_id'],
          'title': row['title'],
          'content': row['content'],
          'summary': row['summary'],
          'importance': row['importance'],
          'created': row['created'],
          'updated': row['updated'],
          'deletedat': row['deletedat'],
          'isarchived': row['isarchived'],
          'isSynced': 1,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      } else {
        // Exists locally — only overwrite if remote is strictly newer.
        // If local is newer (user edited offline), local wins; it will be
        // pushed on a future sync when isSynced = 0.
        final localNote = Note.fromMap(existing.first);
        if (remoteUpdated.isAfter(localNote.updated)) {
          await db.update(
            'NOTES',
            {
              'title': row['title'],
              'content': row['content'],
              'summary': row['summary'],
              'importance': row['importance'],
              'updated': row['updated'],
              'deletedat': row['deletedat'],
              'isarchived': row['isarchived'],
              'isSynced': 1,
            },
            where: 'id = ? AND userId = ?',
            whereArgs: [row['id'], userId],
          );
        }
      }
    }
  }

  // ─── TASKS ───────────────────────────────────────────────────────────────────

  static Future<void> _syncTasks(String userId) async {
    try {
      await _pushTasks(userId);
      await _pullTasks(userId);
    } catch (e) {
      debugPrint('[Sync] Tasks error: $e');
    }
  }

  /// Push all local tasks for this user.
  /// Tasks have no isSynced flag, so we push everything and rely on the
  /// server-side upsert + updated timestamp to avoid overwriting newer data.
  /// Uses Tasks.fromMap() which reads: id, userId, task, isdone, updated.
  /// Also reads isdelete directly from the map (fromMap skips it).
  static Future<void> _pushTasks(String userId) async {
    final db = await _db();

    final maps = await db.query(
      'TASKS',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (maps.isEmpty) return;

    final rows = maps.map((m) {
      final task = Tasks.fromMap(m);
      return {
        'id': task.id,
        'user_id': task.userId,
        'task': task.task,
        // Local DB stores booleans as 0/1 integers; Supabase expects booleans
        'isdone': task.isdone,
        'isdelete': (m['isdelete'] as int? ?? 0) == 1,
        'updated': task.updated.toIso8601String(),
      };
    }).toList();

    await _client.from('tasks').upsert(rows);
  }

  /// Pull remote tasks updated after the local watermark. Last-write-wins.
  static Future<void> _pullTasks(String userId) async {
    final db = await _db();

    final wResult = await db.rawQuery(
      'SELECT MAX(updated) as w FROM TASKS WHERE userId = ?',
      [userId],
    );
    final watermark = wResult.first['w'] as String?;

    final List<dynamic> remote = watermark != null
        ? await _client
              .from('tasks')
              .select()
              .eq('user_id', userId)
              .gt('updated', watermark)
        : await _client.from('tasks').select().eq('user_id', userId);

    for (final row in remote) {
      final remoteUpdated = DateTime.parse(row['updated'] as String);

      final existing = await db.query(
        'TASKS',
        where: 'id = ?',
        whereArgs: [row['id']],
        limit: 1,
      );

      if (existing.isEmpty) {
        // Task from another device — insert it
        await db.insert('TASKS', {
          'id': row['id'],
          'userId': row['user_id'],
          'task': row['task'],
          // Supabase returns booleans; local DB stores as integers
          'isdone': (row['isdone'] as bool) ? 1 : 0,
          'isdelete': (row['isdelete'] as bool) ? 1 : 0,
          'updated': row['updated'],
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      } else {
        final localTask = Tasks.fromMap(existing.first);
        if (remoteUpdated.isAfter(localTask.updated)) {
          await db.update(
            'TASKS',
            {
              'task': row['task'],
              'isdone': (row['isdone'] as bool) ? 1 : 0,
              'isdelete': (row['isdelete'] as bool) ? 1 : 0,
              'updated': row['updated'],
            },
            where: 'id = ? AND userId = ?',
            whereArgs: [row['id'], userId],
          );
        }
      }
    }
  }
}
