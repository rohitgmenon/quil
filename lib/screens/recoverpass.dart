import 'package:flutter/material.dart';
import 'package:quil/screens/resetpassword.dart';
import 'package:quil/supabase/auth/authservice.dart';

class Recoverpass extends StatefulWidget {
  const Recoverpass({super.key});

  @override
  State<Recoverpass> createState() => _RecoverpassState();
}

class _RecoverpassState extends State<Recoverpass> {
  final _email = TextEditingController();
  final authservice = Authservice();
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void recover() async {
    if (_email.text.isEmpty) return;

    setState(() => _isLoading = true);

    final email = _email.text;
    try {
      await authservice.recover(email);
      if (!mounted) return;
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Email Sent"),
          content: const Text("Check your email for Token (check spam too :))"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Resetpassword(email2: email),
                  ),
                );
              },
              child: const Text("ok"),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        children: [
          const SizedBox(height: 40),
          Text(
            "Reset your password",
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : recover,
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'GET TOKEN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
