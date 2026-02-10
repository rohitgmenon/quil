import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OutputScreen extends StatelessWidget {
  final String output;

  const OutputScreen({super.key, this.output = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Output',
          style: GoogleFonts.dmSerifText(
            fontSize: 28,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: output.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.terminal_rounded,
                    size: 100,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: .2),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No output',
                    style: GoogleFonts.dmSerifText(
                      fontSize: 24,
                      color: Theme.of(
                        context,
                      ).colorScheme.inversePrimary.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                output,
                style: GoogleFonts.sourceCodePro(
                  fontSize: 15,
                  height: 1.5,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
    );
  }
}
