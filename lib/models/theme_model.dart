import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners(); // Notify listeners of the change
  }
}
