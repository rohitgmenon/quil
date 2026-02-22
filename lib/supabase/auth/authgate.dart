// lib/supabase/auth/authgate.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quil/components/hiddendraw.dart';
import 'package:quil/screens/loginpage.dart';
import 'package:quil/services/notesprovider.dart';
import 'package:quil/services/sync.dart';
import 'package:quil/services/taskprovider.dart';
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data;

        if (session != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final userId = session.user.id;
            SyncService.syncAll(userId).then((_) {
              if (!context.mounted) return;
              context.read<Notesprovider>().loadnotes();
              context.read<Taskprovider>().loadtasks();
            });
          });

          return const Hiddendraw();
        } else {
          return const Loginpage();
        }
      },
    );
  }
}
