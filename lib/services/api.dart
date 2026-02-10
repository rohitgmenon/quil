// ignore_for_file: unused_local_variable, avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> spellfixer(String text) async {
  try {
    final res = await Supabase.instance.client.functions.invoke(
      'textcorrector',
      body: {'text': text},
    );

    return res.data['correctedText'];
  } catch (e) {
    print('error:$e');
    return text;
  }
}

Future<String> summarizer(String text) async {
  try {
    final res = await Supabase.instance.client.functions.invoke(
      'summarizer',
      body: {'text': text},
    );

    return res.data['summary0'];
  } catch (e) {
    print('error:$e');
    return text;
  }
}

Future<String> debugger(String text) async {
  try {
    final res = await Supabase.instance.client.functions.invoke(
      'debbuger',
      body: {'text': text},
    );

    return res.data['correctedText'];
  } catch (e) {
    print('error:$e');
    return text;
  }
}
