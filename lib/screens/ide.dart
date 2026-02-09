import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';

class Ide extends StatefulWidget {
  const Ide({super.key});

  @override
  State<Ide> createState() => _IdeState();
}

class _IdeState extends State<Ide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            SimpleHiddenDrawerController.of(context).toggle();
          },
          icon: Icon(Icons.menu),
        ),
      ),
    );
  }
}
