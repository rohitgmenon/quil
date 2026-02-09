import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:provider/provider.dart';
import 'package:quil/components/todotile.dart';
import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/services/taskprovider.dart';

class Tasksrceen extends StatefulWidget {
  const Tasksrceen({super.key});

  @override
  State<Tasksrceen> createState() => _TasksrceenState();
}

class _TasksrceenState extends State<Tasksrceen> {
  final taskname = TextEditingController();
  @override
  void dispose() {
    taskname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<Taskprovider>().tasks;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            SimpleHiddenDrawerController.of(context).toggle();
          },
          icon: Icon(Icons.menu),
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, index) {
          final task = tasks[index];
          return Todotile(
            taskname: task.task,
            isdone: task.isdone,
            onchanged: (value) {
              context.read<Taskprovider>().toggle(task);
            },
          );
        },
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: taskname,
                decoration: InputDecoration(
                  hintText: 'ADD A TASK',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () => savetask(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            tooltip: 'Addtask',
            mini: false,
            elevation: 0,
            child: Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }

  void savetask(BuildContext context) {
    final name = taskname.text;
    if (name.isEmpty) return;
    final newtask = Tasks(
      userId: context.read<Taskprovider>().userId,
      task: name,
      isdone: false,
      updated: DateTime.now(),
    );
    context.read<Taskprovider>().addtask(newtask);
    taskname.clear();
  }
}
