// lib/services/notesprovider.dart

import 'package:flutter/material.dart';
import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/loacaldb/dbhelper.dart';
import 'package:quil/services/sync.dart';
import 'package:quil/test/constants.dart';

/// LOCAL-FIRST: every method writes to SQLite first and notifies the UI
/// immediately. SyncService is only invoked once on startup — never here.
class Notesprovider extends ChangeNotifier {
  final String userId;
  Notesprovider(this.userId);

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  List<Note> _delnotes = [];
  List<Note> get delnotes => _delnotes;

  List<Note> _archivedNotes = [];
  List<Note> get archivedNotes => _archivedNotes;

  // ─── LOCAL OPERATIONS (unchanged from original) ────────────────────────────

  Future<void> loadnotes() async {
    _notes = await Dbhelper.fetch(userId);
    notifyListeners();
  }

  Future<void> addnote(Note note) async {
    await Dbhelper.addnote(note);
    await loadnotes();
  }

  Future<void> updatenote(Note note) async {
    await Dbhelper.updateNote(note);
    await loadnotes();
  }

  Future<void> deletenote(Note note) async {
    await Dbhelper.deletenote(note);
    await loadnotes();
    await recyclebin(localuser);
  }

  Future<void> recyclebin(String userId) async {
    _delnotes = await Dbhelper.deletedlist(userId);
    notifyListeners();
  }

  Future<void> restore(Note note) async {
    await Dbhelper.restore(note.id);
    await loadnotes();
    await recyclebin(localuser);
  }

  Future<void> archivedlist(String userId) async {
    _archivedNotes = await Dbhelper.archivedlist(userId);
    notifyListeners();
  }

  Future<void> undo(Note note) async {
    await Dbhelper.unarchive(note.id);
    await loadnotes();
    await archivedlist(localuser);
  }

  Future<void> archivenote(Note note) async {
    await Dbhelper.archivenotes(note);
    await loadnotes();
    await archivedlist(userId);
  }

  // ─── STARTUP SYNC ─────────────────────────────────────────────────────────

  /// Called once from Authgate after session is confirmed.
  /// Pushes unsynced local notes then pulls remote changes, then reloads.
  /// Runs in the background — UI is already showing local data by this point.
  Future<void> syncOnStartup() async {
    await SyncService.syncAll(userId);
    // Reload so the UI reflects any new notes pulled from the server
    await loadnotes();
    await recyclebin(userId);
    await archivedlist(userId);
  }
}
