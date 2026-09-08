// lib/features/profile/cubit/theme_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/shared_prefs_helper.dart';
import 'theme_state.dart';

/// Cubit managing app dark/light mode toggle with persistent SharedPreferences storage.
class ThemeCubit extends Cubit<ThemeState> {
  final SharedPrefsHelper prefsHelper;

  ThemeCubit(this.prefsHelper) : super(const ThemeState()) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = prefsHelper.isDarkMode();
    emit(ThemeState(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> toggleTheme() async {
    final newIsDark = !state.isDarkMode;
    await prefsHelper.setDarkMode(newIsDark);
    emit(ThemeState(themeMode: newIsDark ? ThemeMode.dark : ThemeMode.light));
  }
}

