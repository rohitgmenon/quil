import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quil/supabase/auth/authservice.dart';

class Resetpassword extends StatefulWidget {
  final String email2;

  const Resetpassword({super.key, required this.email2});

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  final authservice = Authservice();
  final _token = TextEditingController();
  final _password = TextEditingController();
  final _confirmpass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Reset Password",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        children: [
          const SizedBox(height: 24),
          TextField(
            controller: _token,

            decoration: InputDecoration(
              labelText: "TOKEN",
              hintText: "Enter your Token",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: const Icon(Icons.key),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Minimum six letters",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: const Icon(Icons.lock_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmpass,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Confirm Password",

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: const Icon(Icons.lock_outlined),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: reset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Reset Password',
                style: GoogleFonts.poppins(
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

  void reset() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    final token = _token.text;
    final email = widget.email2;
    final password = _password.text;
    final confirmpass = _confirmpass.text;
    if (password != confirmpass) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("passwords don't match")));
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      return;
    }

    try {
      await authservice.verify(email, token);
      await authservice.update(confirmpass);
      if (!mounted) return;
      // Just pop the loading dialog — Authgate's stream will
      // detect the new session and navigate to Hiddendraw automatically
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully")),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
