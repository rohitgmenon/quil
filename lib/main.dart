import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quil/services/notesprovider.dart';
import 'package:quil/supabase/auth/authgate.dart';
import 'package:quil/test/constants.dart';
import 'package:quil/themes/themesprovider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    anonKey: 'sb_publishable_LbNcLs0tLoaJ_6h9nFpQPg_S2Z6g6t1',
    url: 'https://nhpbcnbdpaspmsxasxgo.supabase.co',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Notesprovider(localuser)..loadnotes(),
        ),
        ChangeNotifierProvider(create: (context) => Themesprovider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quil',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<Themesprovider>(context).themeData,
      home: Authgate(),
    );
  }
}
