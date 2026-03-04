import 'package:flutter/material.dart';

class Codebar extends StatelessWidget {
  final VoidCallback? onsavepress;
  final VoidCallback? ondeletepress;
  final VoidCallback? onfixpress;
  final VoidCallback? oncampress;
  const Codebar({
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
          IconButton(onPressed: onsavepress, icon: Icon(Icons.save)),
          IconButton(
            onPressed: ondeletepress,
            icon: Icon(Icons.format_line_spacing_rounded),
          ),
          IconButton(onPressed: onfixpress, icon: Icon(Icons.auto_fix_high)),
          IconButton(onPressed: oncampress, icon: Icon(Icons.play_arrow)),
        ],
      ),
    );
  }
}
