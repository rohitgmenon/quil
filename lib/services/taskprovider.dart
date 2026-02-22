// lib/services/taskprovider.dart

import 'package:flutter/foundation.dart';
import 'package:quil/loacaldb/dbhelper.dart';
import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/services/sync.dart';

/// LOCAL-FIRST: every method writes to SQLite first and notifies the UI
/// immediately. SyncService is only invoked once on startup — never here.
class Taskprovider extends ChangeNotifier {
  final String userId;
  Taskprovider(this.userId);

  List<Tasks> _tasks = [];
  List<Tasks> get tasks => _tasks;

  // ─── LOCAL OPERATIONS (unchanged from original) ────────────────────────────

  Future<void> loadtasks() async {
    _tasks = await Dbhelper.getlist();
    notifyListeners();
  }

  Future<void> toggle(Tasks task) async {
    final updated = task.copyWith(isdone: !task.isdone);
    await Dbhelper.updatask(updated);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }

  Future<void> addtask(Tasks task) async {
    await Dbhelper.addtask(task);
    await loadtasks();
  }

  Future<void> deltassk(Tasks task) async {
    await Dbhelper.deltask(task.id);
    _tasks.removeWhere((t) => t.id == task.id);
    notifyListeners();
  }

  // ─── STARTUP SYNC ─────────────────────────────────────────────────────────

  /// Called once from Authgate after session is confirmed.
  /// Pushes local tasks to Supabase then pulls remote changes, then reloads.
  Future<void> syncOnStartup() async {
    await SyncService.syncAll(userId);
    await loadtasks();
  }
}
