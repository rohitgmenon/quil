import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';
import 'package:quil/components/hiddendraw.dart';
import 'package:quil/components/search.dart';
import 'package:quil/loacaldb/notemodel.dart';
// ignore: unused_import
import 'package:quil/screens/archivedscreen.dart';
import 'package:quil/screens/deatilscreen.dart';
import 'package:quil/screens/lockscreen.dart';

import 'package:quil/services/notesprovider.dart';
import 'package:quil/services/securestorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notelist extends StatefulWidget {
  const Notelist({super.key});

  @override
  State<Notelist> createState() => _NotelistState();
}

class _NotelistState extends State<Notelist> {
  @override
  void initState() {
    super.initState();
    context.read<Notesprovider>().loadnotes();
  }

  bool isLocked = false;
  Future<void> onlock(bool value) async {
    final pin = await pinStorage.getPin();
    if (!mounted) return;
    if (value) {
      if (pin == null) {
        setState(() {
          isLocked = false;
        });
        return;
      }
      setState(() {
        isLocked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                SimpleHiddenDrawerController.of(context).toggle();
              },
              icon: Icon(Icons.menu),
            );
          },
        ),

        title: InkWell(
          onLongPress: () async {
            final prefs = await SharedPreferences.getInstance();
            final locked = prefs.getBool('archive_locked') ?? false;
            if (!mounted) return;
            if (!locked) {
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (_) => const ArchivedScreen()),
              );
            } else {
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (_) => const Lockscreen()),
              );
            }
          },
          child: Text(
            'Notes',
            style: GoogleFonts.dmSerifText(
              fontSize: 28,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              onPressed: () => showSearch(context: context, delegate: Search()),
              icon: Icon(Icons.search),
            ),
          ),
        ],
      ),

      body: Expanded(child: mainlist()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => Deatilscreen()),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        tooltip: 'Addnote',
        mini: false,
        elevation: 0,
        child: Icon(
          Icons.add_rounded,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      drawer: Hiddendraw(),
    );
  }

  Widget mainlist() {
    final notes = context.watch<Notesprovider>().notes;
    return notes.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 9),
                  child: Icon(
                    Icons.edit_note,
                    size: 100,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: .2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'No notes yet',
                  style: GoogleFonts.dmSerifText(
                    fontSize: 24,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: .4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to create one',
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
            itemCount: notes.length,

            itemBuilder: (BuildContext context, index) {
              final note = notes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 8.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.1),

                      border: Border(
                        left: BorderSide(
                          color: getcolor(context, note.importance),
                          width: 7,
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 3.5,
                      horizontal: 2.5,
                    ),

                    child: Slidable(
                      startActionPane: ActionPane(
                        motion: StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (ctx) {
                              archive(ctx, note);
                            },
                            backgroundColor: archivetheme(context),
                            foregroundColor: Colors.white,
                            icon: Icons.archive,
                            label: "Archive",
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(note.title),
                        subtitle: Text(
                          note.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        trailing: IconButton(
                          onPressed: () {
                            delete(context, note);
                          },
                          icon: Icon(Icons.delete),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => Deatilscreen(notes: note),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }

  Color getcolor(BuildContext ctx, importance) {
    final Color = Theme.of(ctx).colorScheme;
    switch (importance) {
      case 1:
        return Color.error;

      case 2:
        return Color.tertiary;

      default:
        return Color.tertiary;
    }
  }

  void delete(BuildContext ctx, Note note) {
    ctx.read<Notesprovider>().deletenote(note);
  }

  void loadnotes(BuildContext ctx, Note note) {
    context.read<Notesprovider>().loadnotes();
  }

  void archive(BuildContext ctx, Note note) {
    ctx.read<Notesprovider>().archivenote(note);
  }

  Color archivetheme(BuildContext ctx) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2E7D32)
        : const Color(0xFF4CAF50);
  }
}
