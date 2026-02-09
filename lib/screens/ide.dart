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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _noteController,
          maxLines: null, // Allows unlimited lines
          expands: true, // Expands to fill available space
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            hintText: 'Start coding',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 16,
            ),
          ),
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
