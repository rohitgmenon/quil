// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:provider/provider.dart';
import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/screens/editor.dart';
import 'package:quil/services/codeprovider.dart';
import 'package:google_fonts/google_fonts.dart';

class Ide extends StatefulWidget {
  const Ide({super.key});

  @override
  State<Ide> createState() => _IdeState();
}

class _IdeState extends State<Ide> {
  @override
  void initState() {
    super.initState();
    context.read<Codeprovider>().loadCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            SimpleHiddenDrawerController.of(context).toggle();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      body: Expanded(child: mainlist()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Editor()),
          );
        },
        child: Icon(
          Icons.code,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  Widget mainlist() {
    final Code = context.watch<Codeprovider>().codes;
    return Code.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 9),
                  child: Icon(
                    Icons.code,
                    size: 100,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: .2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Start coding',
                  style: GoogleFonts.dmSerifText(
                    fontSize: 24,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: .4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the <> button to code',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: Code.length,
            itemBuilder: (BuildContext context, int index) {
              final note = Code[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 8.0,
                ),
                child: ListTile(
                  leading: Icon(Icons.code),
                  title: Text(note.filename),
                  subtitle: Text(note.code),
                  trailing: IconButton(
                    onPressed: () {
                      delete(context, note);
                    },
                    icon: Icon(Icons.delete_forever),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Editor(snip: note)),
                    );
                  },
                ),
              );
            },
          );
  }

  void load(BuildContext ctx, Code code) {
    context.read<Codeprovider>().loadCodes();
  }

  void delete(BuildContext ctx, Code code) {
    ctx.read<Codeprovider>().deleteCode(code);
  }
}
