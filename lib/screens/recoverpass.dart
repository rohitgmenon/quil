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
  void recover() async {
    final email = _email.text;
    await authservice.recover(email);
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Email Sent"),
        content: const Text("Check your email for Token(check the spam to :))"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Resetpassword(email2: email)),
              );
            },
            child: const Text("ok"),
          ),
        ],
      ),
    );
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
              onPressed: recover,
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'GET TOKEN',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
