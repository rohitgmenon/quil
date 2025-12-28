import 'package:flutter/material.dart';
import 'package:quil/screens/deatilscreen.dart';

class Notelist extends StatefulWidget {
  const Notelist({super.key});

  @override
  State<Notelist> createState() => _NotelistState();
}

class _NotelistState extends State<Notelist> {
  int count = 0;
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
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.yellow),
            title: Text('Dummy title'),
            subtitle: Text('dummy'),
            onTap: () {},
          ),
        );
      },
    );
  }
}
