import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quil/screens/notelist.dart';
import 'package:quil/services/notesprovider.dart';
import 'package:quil/test/constants.dart';
import 'package:quil/themes/themesprovider.dart';

void main() {
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
      home: Notelist(),
    );
  }
}
