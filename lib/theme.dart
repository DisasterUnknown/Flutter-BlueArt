import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: Colors.deepPurple,
      background: Colors.white,
      surface: Colors.white,
      onPrimary: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: Colors.red,
      background: Colors.black,
      surface: Colors.black,
      onPrimary: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.red,
      foregroundColor: Colors.black,
    ),
  );
}
