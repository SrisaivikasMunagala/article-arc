import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false; // Default is light mode

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference(); // Load saved theme preference on initialization
  }

  // Toggle the theme between light and dark
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemePreference(); // Save the new preference
    notifyListeners(); // Notify listeners about the theme change
  }

  // Save theme preference to local storage
  void _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  // Load theme preference from local storage
  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false; // Default to light mode
    notifyListeners(); // Notify listeners in case the theme needs updating
  }
}
