import 'package:flutter/material.dart';
import 'package:quil/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Themesprovider with ChangeNotifier {
  ThemeData _themeData = lightmode;
  late SharedPreferences _prefs;
  static const String _themeKey = 'isDarkMode';

  ThemeData get themeData => _themeData;
  bool get isDark => _themeData == darkmode;

  // Load saved theme on app startup
  Future<void> initializeTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final isDark = _prefs.getBool(_themeKey) ?? false;
    _themeData = isDark ? darkmode : lightmode;
    notifyListeners();
  }

  void toggle() {
    if (_themeData == lightmode) {
      _themeData = darkmode;
    } else {
      _themeData = lightmode;
    }
    _prefs.setBool(_themeKey, isDark); // Save directly
    notifyListeners();
  }
}
