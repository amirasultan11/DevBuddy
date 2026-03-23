import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// LocaleProvider manages the app language/locale state
/// and notifies listeners when the language changes
class LocaleProvider extends ChangeNotifier {
  // هنخلي الديفولت إنجليزي أو عربي زي ما تحبي، بس هو كده كده هيقرا من الـ Hive
  Locale _locale = const Locale('en'); 

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  // دالة بتقرأ اللغة المحفوظة أول ما التطبيق يفتح
  void _loadSavedLocale() {
    final box = Hive.box('settings');
    final String? savedLanguage = box.get('language_code');
    
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  // دالة بتغير اللغة وتحفظها في الـ Hive عشان متضيعش
  void setLocale(Locale locale) {
    if (!['en', 'ar'].contains(locale.languageCode)) return;

    _locale = locale;
    
    // حفظ اللغة في الـ Hive
    final box = Hive.box('settings');
    box.put('language_code', locale.languageCode);
    
    notifyListeners();
  }

  // دالة مساعدة لو حابة تعملي زرار يبدل بين اللغتين في الإعدادات
  void toggleLanguage() {
    final newLocale = _locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    setLocale(newLocale);
  }
}
