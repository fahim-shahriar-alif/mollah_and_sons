import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  static const String _languageKey = 'selected_language';
  
  Locale _currentLocale = const Locale('en', 'US');
  
  Locale get currentLocale => _currentLocale;
  
  bool get isBengali => _currentLocale.languageCode == 'bn';
  bool get isEnglish => _currentLocale.languageCode == 'en';

  // Initialize language from saved preferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    
    if (languageCode == 'bn') {
      _currentLocale = const Locale('bn', 'BD');
    } else {
      _currentLocale = const Locale('en', 'US');
    }
    
    notifyListeners();
  }

  // Toggle between English and Bengali
  Future<void> toggleLanguage() async {
    if (_currentLocale.languageCode == 'en') {
      await setLanguage('bn');
    } else {
      await setLanguage('en');
    }
  }

  // Set specific language
  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    
    if (languageCode == 'bn') {
      _currentLocale = const Locale('bn', 'BD');
    } else {
      _currentLocale = const Locale('en', 'US');
    }
    
    notifyListeners();
  }

  // Get supported locales
  static List<Locale> get supportedLocales => [
    const Locale('en', 'US'),
    const Locale('bn', 'BD'),
  ];
}
