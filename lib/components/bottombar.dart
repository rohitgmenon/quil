import 'package:flutter/material.dart';

class Bottombar extends StatelessWidget {
  final VoidCallback? onsavepress;
  final VoidCallback? ondeletepress;
  final VoidCallback? onfixpress;
  final VoidCallback? oncampress;

  const Bottombar({
    super.key,
    this.onsavepress,
    this.ondeletepress,
    this.onfixpress,
    this.oncampress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(onPressed: onsavepress, icon: const Icon(Icons.save)),
          IconButton(onPressed: ondeletepress, icon: const Icon(Icons.flag)),
          IconButton(
            onPressed: onfixpress,
            icon: const Icon(Icons.auto_fix_high),
          ),
          IconButton(onPressed: oncampress, icon: const Icon(Icons.summarize)),
        ],
      ),
    );
  }
}
