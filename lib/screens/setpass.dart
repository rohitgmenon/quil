import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:quil/services/securestorage.dart';

class Setpass extends StatefulWidget {
  const Setpass({super.key});

  @override
  State<Setpass> createState() => _SetpassState();
}

class _SetpassState extends State<Setpass> {
  final _pin = TextEditingController();
  final _confirmed = TextEditingController();
  Future<void> save() async {
    String pin = _pin.text;
    if (pin.length != 4 || int.tryParse(pin) == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter a valid 4-digit pin")));
      return;
    }
    await pinStorage.savepin(pin);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
   
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Set Password",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        children: [
          const SizedBox(height: 24),
          TextField(
            keyboardType: TextInputType.number,
            controller: _pin,
            decoration: InputDecoration(
              labelText: "Pin",
              hintText: "Enter your pin",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: const Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            controller: _confirmed,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "PIN",
              hintText: "Confirm your pin",
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
          const SizedBox(height: 24),
          
          SizedBox(
            
            height: 52,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: save,
              icon: Icon(Icons.check, size: 20, color: Theme.of(context).colorScheme.inversePrimary),
              label: Text(
                "Set",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
