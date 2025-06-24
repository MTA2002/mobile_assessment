import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(const ThemeState(ThemeMode.light)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      final themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      emit(ThemeState(themeMode));
    } catch (e) {
      // If there's an error loading the theme, default to light
      emit(const ThemeState(ThemeMode.light));
    }
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, themeMode == ThemeMode.dark);
    } catch (e) {
      // Handle error silently
    }
  }

  void toggleTheme() {
    final currentMode = state.themeMode;
    final newMode =
        currentMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    emit(ThemeState(newMode));
    _saveTheme(newMode);
  }

  void setTheme(ThemeMode themeMode) {
    // Only allow light and dark themes
    if (themeMode == ThemeMode.light || themeMode == ThemeMode.dark) {
      emit(ThemeState(themeMode));
      _saveTheme(themeMode);
    }
  }
}
