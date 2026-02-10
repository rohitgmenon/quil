import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    error: Colors.red,
    tertiary: Colors.blueGrey,

    primary: Colors.grey.shade300,
    onPrimaryContainer: Colors.grey.shade100,
    secondary: Colors.grey.shade600,
    inversePrimary: Colors.black,
  ),
);
ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    error: Colors.redAccent,
    tertiary: Colors.blueGrey,

    primary: Colors.grey.shade800,
    onPrimaryContainer: Colors.grey.shade200,
    secondary: Colors.grey.shade700,
    inversePrimary: Colors.white,
  ),
);
