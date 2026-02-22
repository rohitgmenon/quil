import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quil/loacaldb/notemodel.dart';
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
                        archive(context, note);
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
                        archive(context, note);
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

  Color getcolor(BuildContext context, int importance) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (importance) {
      case 1:
        return colorScheme.error;
      case 2:
        return colorScheme.tertiary;
      default:
        return colorScheme.tertiary;
    }
  }

  void delete(BuildContext context, Note note) {
    context.read<Notesprovider>().deletenote(note);
  }

  void archive(BuildContext context, Note note) {
    context.read<Notesprovider>().archivenote(note);
  }

  Color archivetheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2E7D32)
        : const Color(0xFF4CAF50);
  }
}
