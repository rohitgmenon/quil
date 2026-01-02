import 'package:flutter/material.dart';
import 'package:quil/components/drawertile.dart';
import 'package:quil/screens/settings.dart';

class Mydraw extends StatelessWidget {
  const Mydraw({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const DrawerHeader(child: Icon(Icons.note)),
          Drawertile(
            leading: const Icon(Icons.settings),
            title: "Settings",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => Settings()),
              );
            },
          ),
        ],
      ),
    );
  }
}
