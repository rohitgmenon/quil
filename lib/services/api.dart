// ignore_for_file: unused_local_variable

import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> spellfixer(String text) async {
  try {
    final res = await Supabase.instance.client.functions.invoke(
      'textcorrector',
      body: {'text': 'text'},
    );
    return res.data['correctedText'];
  } catch (e) {
    final String Error = 'error:$e';
    return text;
  }
}
