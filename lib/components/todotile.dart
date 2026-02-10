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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.inversePrimary.withValues(alpha: .1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: isdone,
              onChanged: onchanged,
              checkColor: Theme.of(context).colorScheme.surface,
              activeColor: Theme.of(context).colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 8),
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
                decorationThickness: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
