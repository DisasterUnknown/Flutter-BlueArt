import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF90CAF9),
      surface: Colors.white,
      onPrimary: Colors.black,
      onSurfaceVariant: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22.0,),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF90CAF9),
      foregroundColor: Colors.white,
    ),
  );

  static final darkTheme = ThemeData(
    
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF0D47A1),
      surface: Colors.black,
      onPrimary: Colors.white,
      onSurfaceVariant: const Color.fromARGB(176, 44, 44, 44),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.0,),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF0D47A1),
      foregroundColor: Colors.black,
    ),
  );
}
