import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quil/screens/notelist.dart';
import 'package:quil/services/notesprovider.dart';
import 'package:quil/test/constants.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Notesprovider(localuser)..loadnotes(),
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Notelist(),
    );
  }
}
