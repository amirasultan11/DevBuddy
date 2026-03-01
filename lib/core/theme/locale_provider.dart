import 'package:flutter/material.dart';

/// LocaleProvider manages the app language/locale state
/// and notifies listeners when the language changes
class LocaleProvider extends ChangeNotifier {
  // Private locale variable - default is Arabic
  Locale _locale = const Locale('ar');

  /// Getter to access the current locale
  Locale get locale => _locale;

  /// Set a new locale and notify all listeners
  ///
  /// [locale] - The new locale to set (e.g., Locale('ar') or Locale('en'))
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners(); // Notify all listeners about the locale change
  }
}
