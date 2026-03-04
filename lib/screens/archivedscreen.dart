import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quil/loacaldb/notemodel.dart';
import 'package:quil/screens/deatilscreen.dart';
import 'package:quil/services/notesprovider.dart';
import 'package:quil/test/constants.dart';

class ArchivedScreen extends StatefulWidget {
  const ArchivedScreen({super.key});

  @override
  State<ArchivedScreen> createState() => _ArchivedScreenState();
}

class _ArchivedScreenState extends State<ArchivedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<Notesprovider>().archivedlist(localuser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        centerTitle: true,

        title: Text(
          ' Archived Notes',
          style: GoogleFonts.dmSerifText(
            fontSize: 28,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),

      body: mainlist(),
    );
  }

  ListView mainlist() {
    final notes = context.watch<Notesprovider>().archivedNotes;
    return ListView.builder(
      itemCount: notes.length,

      itemBuilder: (BuildContext context, index) {
        final note = notes[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
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
            margin: const EdgeInsets.symmetric(vertical: 3.5, horizontal: 2.5),

            child: Slidable(
              startActionPane: ActionPane(
                motion: StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (ctx) {
                      unarchive(ctx, note);
                    },
                    backgroundColor: archivetheme(context),
                    foregroundColor: Colors.white,
                    icon: Icons.unarchive,
                    label: "Unarchive",
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

  Color archivetheme(BuildContext ctx) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2E7D32)
        : const Color(0xFF4CAF50);
  }

  void delete(BuildContext ctx, Note note) async {
    await ctx.read<Notesprovider>().deletenote(note);
    // ignore: use_build_context_synchronously
    await ctx.read<Notesprovider>().archivedlist(localuser);
  }

  void unarchive(BuildContext ctx, Note note) {
    ctx.read<Notesprovider>().undo(note);
  }
}
