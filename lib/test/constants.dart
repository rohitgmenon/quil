import 'package:supabase_flutter/supabase_flutter.dart';

final base = Supabase.instance.client;
final localuser = base.auth.currentUser!.id;
bool isloadind = false;
