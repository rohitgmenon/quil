import 'package:flutter/material.dart';

class Todotile extends StatelessWidget {
  const Todotile({
    super.key,
    required this.taskname,
    required this.isdone,
    this.onchanged,
  });
  final String taskname;
  final bool isdone;
  final Function(bool?)? onchanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        child: Row(
          children: [
            Checkbox(
              value: isdone,
              onChanged: onchanged,
              checkColor: Theme.of(context).colorScheme.inversePrimary,
              shape: CircleBorder(),
            ),
            Expanded(
              child: Text(
                taskname,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16,
                  decoration: isdone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: Theme.of(context).colorScheme.inversePrimary,
                  decorationThickness: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
