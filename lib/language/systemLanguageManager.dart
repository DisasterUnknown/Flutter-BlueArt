// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:blue_art_mad2/services/localSharedPreferences.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';

class CustomLanguages {
  static List<Map<String, dynamic>>? japaneseLanguage;
  static List<Map<String, dynamic>>? englishLanguage;

  // cache pref language for sync access
  static String _prefLanguage = 'en';

  /// Load JSON language files at app startup
  static Future<void> init() async {
    await _loadLanguages();
    await loadPreference();
  }

  /// Load JSON language files once
  static Future<void> _loadLanguages() async {
    if (japaneseLanguage != null && englishLanguage != null) return;

    final japaneseJson = await rootBundle.loadString('lib/language/ja.json');
    final englishJson = await rootBundle.loadString('lib/language/en.json');

    final List<dynamic> japaneseList = jsonDecode(japaneseJson);
    final List<dynamic> englishList = jsonDecode(englishJson);

    japaneseLanguage = japaneseList.map((e) => Map<String, dynamic>.from(e)).toList();
    englishLanguage = englishList.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Load preferred language once and cache it
  static Future<void> loadPreference() async {
    final prefLang = await LocalSharedPreferences.getString(SharedPrefValues.prefLanguage);
    _prefLanguage = prefLang ?? 'en';
  }

  /// returns Japanese if pref, fallback to English
  static String getTextSync(String tag, {String fallback = 'No Tag'}) {
    bool useJapanese = _prefLanguage.toLowerCase() == 'ja';

    String? value;

    // Try Japanese first
    if (useJapanese && japaneseLanguage != null) {
      value = japaneseLanguage!.firstWhere(
        (item) => item['tag'] == tag,
        orElse: () => {},
      )['value'];
    }

    // If missing or empty, fallback to English
    if (value == null || value.isEmpty) {
      value = englishLanguage?.firstWhere(
        (item) => item['tag'] == tag,
        orElse: () => {},
      )['value'];
    }

    return value ?? fallback;
  }
}
