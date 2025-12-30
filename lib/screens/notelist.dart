import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/screens/deatilscreen.dart';
import 'package:quil/services/notesprovider.dart';

class Notelist extends StatefulWidget {
  const Notelist({super.key});

  @override
  State<Notelist> createState() => _NotelistState();
}

class _NotelistState extends State<Notelist> {
  int count = 0;
  @override
  void initState() {
    super.initState();
    context.read<Notesprovider>().loadnotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: mainlist(),
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
    );
  }

  ListView mainlist() {
    final notes = context.watch<Notesprovider>().notes;
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (BuildContext context, index) {
        final note = notes[index];
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getcolor(note.importance),
              child: geticon(note.importance),
            ),
            title: Text(note.title),
            subtitle: Text(note.content),
            trailing: IconButton(
              onPressed: () {
                delete(context, note);
              },
              icon: Icon(Icons.delete),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => Deatilscreen(notes: note)),
              );
            },
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
        return Icon(Icons.play_arrow);

      case 2:
        return Icon(Icons.keyboard_arrow_right);

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void delete(BuildContext ctx, Note note) {
    ctx.read<Notesprovider>().deletenote(note);
  }
}
