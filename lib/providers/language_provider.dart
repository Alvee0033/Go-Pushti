import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'bn'; // Default to Bengali
  
  String get currentLanguage => _currentLanguage;
  bool get isBengali => _currentLanguage == 'bn';
  bool get isEnglish => _currentLanguage == 'en';

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language') ?? 'bn';
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _currentLanguage = _currentLanguage == 'bn' ? 'en' : 'bn';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _currentLanguage);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    if (lang != 'bn' && lang != 'en') return;
    _currentLanguage = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _currentLanguage);
    notifyListeners();
  }

  // Translation helper
  String t(String bn, String en) {
    return _currentLanguage == 'bn' ? bn : en;
  }
}
