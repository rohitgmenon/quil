import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:quil/screens/archivedscreen.dart';
import 'package:quil/services/securestorage.dart';

class Lockscreen extends StatefulWidget {
  const Lockscreen({super.key});

  @override
  State<Lockscreen> createState() => _LockscreenState();
}

class _LockscreenState extends State<Lockscreen> {
  String? _storedPin;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPin();
  }

  Future<void> _loadPin() async {
    try {
      final pin = await pinStorage.getPin();
      setState(() {
        _storedPin = pin;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error loading PIN: $e")));
      }
    }
  }

  void _onUnlocked() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ArchivedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_storedPin == null) {
      return Scaffold(
        body: Center(child: Text("No PIN set. Please set a PIN first.")),
      );
    }

    return Scaffold(
      body: ScreenLock(correctString: _storedPin!, onUnlocked: _onUnlocked),
    );
  }
}
