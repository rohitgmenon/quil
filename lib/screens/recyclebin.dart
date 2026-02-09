import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:provider/provider.dart';
import 'package:quil/services/notesprovider.dart';
import 'package:quil/test/constants.dart';

class Bin extends StatefulWidget {
  const Bin({super.key});

  @override
  State<Bin> createState() => _BinState();
}

class _BinState extends State<Bin> {
  @override
  void initState() {
    super.initState();
    context.read<Notesprovider>().recyclebin(localuser);
  }

  @override
  Widget build(BuildContext context) {
    final notelist = context.watch<Notesprovider>().delnotes;
    return Scaffold(
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
        title: Text(
          "Recycle Bin",
          style: GoogleFonts.dmSerifText(
            fontSize: 28,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: notelist.length,
          itemBuilder: (context, index) {
            final note = notelist[index];
            return ListTile(
              title: Text(note.title),
              subtitle: Text(note.content),
              trailing: IconButton(
                onPressed: () {
                  context.read<Notesprovider>().restore(note);
                },
                icon: const Icon(Icons.restore),
              ),
            );
          },
        ),
      ),
    );
  }
}
