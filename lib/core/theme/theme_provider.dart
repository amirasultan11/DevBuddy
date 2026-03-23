import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  // الديفولت يكون زي النظام (System)
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    final box = Hive.box('settings');
    final String? savedTheme = box.get('theme_mode');
    
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    Hive.box('settings').put('theme_mode', mode.toString());
    notifyListeners();
  }
}