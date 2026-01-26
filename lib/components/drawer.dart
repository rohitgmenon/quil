import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quil/components/drawertile.dart';
import 'package:quil/screens/recyclebin.dart';
import 'package:quil/screens/settings.dart';
import 'package:quil/supabase/auth/authservice.dart';

class Mydraw extends StatelessWidget {
  Mydraw({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(50),
            child: Container(
              height: 72,
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 14),
              child: Text("Menu", style: GoogleFonts.poppins(fontSize: 24)),
            ),
          ),

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

          Drawertile(
            leading: const Icon(Icons.logout),
            title: "logout",
            onTap: logout,
          ),
          Drawertile(
            leading: const Icon(Icons.delete_rounded),
            title: "Trash",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bin()),
              );
            },
          ),
        ],
      ),
    );
  }

  final auth = Authservice();
  void logout() async {
    await auth.signout();
  }
}
