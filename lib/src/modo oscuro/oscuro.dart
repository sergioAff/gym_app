import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  final String _themePreferenceKey = 'isDarkMode';
  final String _favoritesKey = 'favorites';
  
  // Lista de favoritos
  Set<String> _favorites = {};

  bool get isDarkMode => _isDarkMode;
  Set<String> get favorites => _favorites;

  ThemeProvider() {
    _loadPreferences();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemePreference();
    notifyListeners();
  }

  // Métodos para gestionar favoritos
  bool isFavorite(String exerciseName) {
    return _favorites.contains(exerciseName);
  }

  void toggleFavorite(String exerciseName) {
    if (_favorites.contains(exerciseName)) {
      _favorites.remove(exerciseName);
    } else {
      _favorites.add(exerciseName);
    }
    _saveFavorites();
    notifyListeners();
  }

  void _loadPreferences() async {
    await _loadThemePreference();
    await _loadFavorites();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> savedFavorites = prefs.getStringList(_favoritesKey) ?? [];
    _favorites = Set<String>.from(savedFavorites);
    notifyListeners();
  }

  void _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePreferenceKey, _isDarkMode);
    print('Theme preference saved: $_isDarkMode');
  }
  
  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favorites.toList());
  }
}

