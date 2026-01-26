import 'package:flutter/material.dart';
import 'package:quil/screens/loginpage.dart';

import 'package:quil/screens/notelist.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Session?>(
      stream: Supabase.instance.client.auth.onAuthStateChange.map(
        (data) => data.session,
      ),
      builder: (context, snapshot) {
        final session = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (session != null) {
          return Notelist();
        } else {
          return Loginpage();
        }
      },
    );
  }
}
