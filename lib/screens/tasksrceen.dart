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
          icon: const Icon(Icons.menu),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskname,
                    decoration: InputDecoration(
                      hintText: 'Add a new task...',
                      hintStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.inversePrimary.withValues(alpha: .5),
                      ),
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: .1),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.inversePrimary.withValues(alpha: .3),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onSubmitted: (_) => savetask(context),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: () => savetask(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  elevation: 2,
                  child: Icon(
                    Icons.add_rounded,
                    color: Theme.of(context).colorScheme.surface,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          // Tasks list
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt_outlined,
                          size: 80,
                          color: Theme.of(
                            context,
                          ).colorScheme.inversePrimary.withValues(alpha: .3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(
                              context,
                            ).colorScheme.inversePrimary.withValues(alpha: .5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Slidable(
                          key: ValueKey(task.task + task.updated.toString()),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.25,
                            children: [
                              SlidableAction(
                                onPressed: (context) => del(context, task),
                                backgroundColor: const Color(0xFFF65555),
                                foregroundColor: Colors.white,
                                icon: Icons.delete_rounded,
                                label: "Delete",
                                borderRadius: BorderRadius.circular(12),
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void savetask(BuildContext context) {
    final name = taskname.text.trim();
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

  void del(BuildContext ctx, Tasks task) {
    context.read<Taskprovider>().deltassk(task);
  }
}
