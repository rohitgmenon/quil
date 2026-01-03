import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quil/services/notesprovider.dart';
import 'package:quil/screens/deatilscreen.dart';

class Search extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final allNotes = context.read<Notesprovider>().notes;
    final results = allNotes
        .where(
          (note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    if (results.isEmpty) {
      return Center(child: Text('No notes found'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, index) {
        final note = results[index];
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

  @override
  Widget buildSuggestions(BuildContext context) {
    final allNotes = context.read<Notesprovider>().notes;
    final suggestions = query.isEmpty
        ? []
        : allNotes
              .where(
                (note) =>
                    note.title.toLowerCase().contains(query.toLowerCase()) ||
                    note.content.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

    if (suggestions.isEmpty && query.isNotEmpty) {
      return Center(child: Text('No notes found'));
    }

    if (query.isEmpty) {
      return Center(child: Text('Start typing to search notes'));
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, index) {
        final note = suggestions[index];
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
}
