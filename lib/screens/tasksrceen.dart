import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
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
        centerTitle: true,
        title: Text(
          "Tasks",
          style: GoogleFonts.dmSerifText(
            fontSize: 28,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, index) {
          final task = tasks[index];
          return Slidable(
            startActionPane: ActionPane(
              motion: StretchMotion(),
              extentRatio: 0.30,
              children: [
                SlidableAction(
                  onPressed: (context) => del(context, task),
                  backgroundColor: deletetheme(context),
                  foregroundColor: Colors.white,
                  icon: Icons.delete_rounded,
                  label: "DELETE",
                ),
              ],
            ),

            child: Todotile(
              taskname: task.task,
              isdone: task.isdone,
              onchanged: (value) {
                context.read<Taskprovider>().toggle(task);
              },
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: taskname,
                  decoration: InputDecoration(
                    hintText: 'ADD A TASK',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),

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
              child: Icon(
                Icons.add_rounded,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ],
        ),
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

  Color deletetheme(BuildContext ctx) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(206, 246, 5, 5)
        : const Color.fromARGB(206, 246, 5, 5);
  }

  void del(BuildContext ctx, Tasks task) {
    context.read<Taskprovider>().deltassk(task);
  }
}
