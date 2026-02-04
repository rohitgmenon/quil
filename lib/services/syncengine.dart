import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/services/dbhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Syncengine {
  final SupabaseClient supabase;
  Syncengine(this.supabase);
  Future<void> sync(String userId) async {
    final enabled = await SyncSeetings.isenabled();
    if (enabled) {
      await pushlocal(userId);
    }
  }

  Future<void> retrive(String userId) async {
    await pullcloud(userId);
  }

  Future<void> pushlocal(String userId) async {
    final unsynced = await Dbhelper.unsynced(userId);
    for (final note in unsynced) {
      await supabase
          .from('cloud table')
          .upsert(note.tocloudMap(), onConflict: 'id');
      await Dbhelper.marked(note.id);
    }
  }

  Future<void> pullcloud(String userId) async {
    final res = await supabase
        .from('cloud table')
        .select()
        .eq('user _id', userId);
    final cloudnotes = (res as List).map((m) => Note.fromcloud(m)).toList();
    for (final cloudnote in cloudnotes) {
      final unsynced = await Dbhelper.getbyid(cloudnote.id);
      if (unsynced == null) {
        await Dbhelper.upsertlocal(cloudnote);
        continue;
      }
      if (cloudnote.updated.isAfter(unsynced.updated)) {
        await Dbhelper.upsertlocal(cloudnote);
      }
    }
  }
}

class SyncSeetings {
  static const _key = 'cloud sync enabled';
  static Future<bool> isenabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true;
  }

  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
