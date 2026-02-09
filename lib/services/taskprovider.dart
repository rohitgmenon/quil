import 'package:flutter/foundation.dart';
import 'package:quil/loacaldb/dbhelper.dart';
import 'package:quil/loacaldb/notemodel.dart';

class Taskprovider extends ChangeNotifier {
  final String userId;
  Taskprovider(this.userId);
  List<Tasks> _tasks = [];
  List<Tasks> get tasks => _tasks;
  Future<void> loadtasks() async {
    _tasks = await Dbhelper.getlist();
    notifyListeners();
  }

  Future<void> toggle(Tasks task) async {
    final newtask = task.copyWith(isdone: !task.isdone);
    await Dbhelper.updatask(newtask);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = newtask;

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
}
