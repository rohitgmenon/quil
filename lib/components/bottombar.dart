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
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: IconButton(onPressed: onsavepress, icon: Icon(Icons.save)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: IconButton(onPressed: ondeletepress, icon: Icon(Icons.flag)),
          ),
          Padding(
            padding: const EdgeInsets.all(36),
            child: IconButton(
              onPressed: onfixpress,
              icon: Icon(Icons.auto_fix_high),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: oncampress,
              icon: Icon(Icons.summarize),
            ),
          ),
        ],
      ),
    );
  }
}
