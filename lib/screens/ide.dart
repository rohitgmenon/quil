import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';

class Ide extends StatefulWidget {
  const Ide({super.key});

  @override
  State<Ide> createState() => _IdeState();
}

class _IdeState extends State<Ide> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

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
      body: Stack(),
    );
  }
}
