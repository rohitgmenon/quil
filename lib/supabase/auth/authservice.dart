import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authservice extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  //sign in
  Future<AuthResponse> Signinemail(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  //signup

  Future<AuthResponse> signup(String email, String password) async {
    return _supabase.auth.signUp(email: email, password: password);
  }

  //signout
  Future<void> signout() async {
    return await _supabase.auth.signOut();
  }

  Future<void> recover(String email) async {
    return await _supabase.auth.resetPasswordForEmail(email);
  }

  //get user email
  String? getuser() {
    final Session = _supabase.auth.currentSession;
    final user = Session?.user;
    return user?.email;
  }
}
