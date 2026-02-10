import 'package:supabase_flutter/supabase_flutter.dart';

final base = Supabase.instance.client;
final localuser = base.auth.currentUser!.id;
bool isloadind = false;
/*body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _noteController,
          maxLines: null, // Allows unlimited lines
          expands: true, // Expands to fill available space
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            hintText: 'Start coding',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 16,
            ),
          ),
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ),*/
//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
