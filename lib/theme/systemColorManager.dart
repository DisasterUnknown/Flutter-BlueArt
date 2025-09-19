import 'package:blue_art_mad2/theme/darkTheme.dart';
import 'package:blue_art_mad2/theme/lightTheme.dart';
import 'package:flutter/material.dart';

class CustomColors {
  static Color getThemeColor(BuildContext context, String colorName) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final themeColors = brightness == Brightness.dark ? darkThemeColors : lightThemeColors;

    try {
      final Map<String, dynamic> colorMap =
          themeColors.firstWhere((c) => c['name'] == colorName);
      return Color(colorMap['value']);
    } catch (e) {
      debugPrint('Color "$colorName" not found in theme!');
      return const Color.fromARGB(255, 255, 0, 0); // fallback
    }
  }
}
