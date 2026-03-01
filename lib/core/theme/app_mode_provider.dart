import 'package:flutter/material.dart';

/// AppModeProvider manages the app mode state (Kids Mode vs Professional Mode)
/// and notifies listeners when the mode changes
class AppModeProvider extends ChangeNotifier {
  // Private boolean to track if Kids Mode is active
  bool _isKidsMode = false;

  /// Getter to access the current mode state
  bool get isKidsMode => _isKidsMode;

  /// Toggle the app mode between Kids and Professional
  ///
  /// [value] - true for Kids Mode, false for Professional Mode
  void toggleMode(bool value) {
    _isKidsMode = value;
    notifyListeners(); // Notify all listeners about the state change
  }
}
