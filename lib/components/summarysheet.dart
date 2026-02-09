import 'package:flutter/material.dart';
import 'package:quil/services/api.dart';

class Summarysheet extends StatefulWidget {
  final String content;
  final String? initialsummary;
  const Summarysheet({super.key, required this.content, this.initialsummary});

  @override
  State<Summarysheet> createState() => _SummarysheetState();
}

class _SummarysheetState extends State<Summarysheet> {
  late String? summary;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    summary = widget.initialsummary;
  }

  Future<void> generate() async {
    setState(() => loading = true);
    summary = await summarizer(widget.content);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hassummary = summary != null && summary!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!hassummary)
            ElevatedButton(
              onPressed: loading ? null : generate,
              child: Text(
                loading ? "Generating..." : "Generate Summary",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(summary!),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(
                          context,
                          '',
                        ), // Return empty string to delete
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text("Delete Summary"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, summary),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
