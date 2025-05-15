import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF90CAF9),
      onPrimaryContainer: Color.fromARGB(255, 35, 46, 255),                 // Selected Nav 
      surface: Colors.white,                                                // Background Color and Bottom Nav Bar Unselected Icon Color
      surfaceContainerHighest: const Color.fromARGB(255, 224, 224, 224),
      onPrimary: Colors.black,                                              // Hamburger Icon Color
      onSurfaceVariant: Colors.white,                                       // Drawer Background Color
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30.0,),
      bodyLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22.0,),
      bodyMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0,),
      bodySmall: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0,),

      labelMedium: TextStyle(color: Color.fromARGB(255, 101, 101, 101), fontWeight: FontWeight.bold, fontSize: 20.0,),
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
      onPrimaryContainer: Colors.white,                                     // Selected Nav 
      surface: Colors.black,                                                // Background Color and Bottom Nav Bar Unselected Icon Color
      surfaceContainerHighest: const Color.fromARGB(255, 37, 37, 37),
      onPrimary: Colors.white,                                              // Hamburger Icon Color
      onSurfaceVariant: const Color.fromARGB(176, 44, 44, 44),              // Drawer Background Color
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0,),
      bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.0,),
      bodyMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,),
      bodySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),
      
      labelMedium: TextStyle(color: Color.fromARGB(255, 110, 110, 110), fontWeight: FontWeight.bold, fontSize: 20.0,),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF0D47A1),
      foregroundColor: Colors.black,
    ),
  );
}
