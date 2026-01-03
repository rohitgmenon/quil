import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quil/components/drawer.dart';
import 'package:quil/components/search.dart';
import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/screens/deatilscreen.dart';
import 'package:quil/services/notesprovider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        centerTitle: true,

        title: Text(
          'Notes',
          style: GoogleFonts.dmSerifText(
            fontSize: 28,
            color: Theme.of(context).colorScheme.inversePrimary,
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
        tooltip: 'Addnote',
        child: Icon(Icons.add),
      ),
      drawer: const Mydraw(),
    );
  }

  ListView mainlist() {
    final notes = context.watch<Notesprovider>().notes;
    return ListView.builder(
      itemCount: notes.length,

      itemBuilder: (BuildContext context, index) {
        final note = notes[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 3.5, horizontal: 2.5),
            color: Theme.of(context).colorScheme.surface,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getcolor(note.importance),
                child: geticon(note.importance),
              ),
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
        );
      },
    );
  }

  Color getcolor(int importance) {
    switch (importance) {
      case 1:
        return Colors.red;

      case 2:
        return Colors.yellow;

      default:
        return Colors.yellow;
    }
  }

  Icon geticon(int importance) {
    switch (importance) {
      case 1:
        return Icon(Icons.priority_high_outlined);

      case 2:
        return Icon(Icons.low_priority_outlined);

      default:
        return Icon(Icons.low_priority_outlined);
    }
  }

  void delete(BuildContext ctx, Note note) {
    ctx.read<Notesprovider>().deletenote(note);
  }

  void loadnotes(BuildContext ctx, Note note) {
    context.read<Notesprovider>().loadnotes();
  }
}
