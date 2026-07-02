import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journi/providers/shared_prefs_provider.dart';

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final prefs = ref.read(sharedPrefsProvider);
    final theme = prefs.getString('theme');
    return theme != null
        ? ThemeMode.values.firstWhere(
          (e) => e.toString() == theme,
      orElse: () => ThemeMode.system,
    )
        : ThemeMode.system;
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setString('theme', mode.toString());
    state = AsyncData(mode);
  }
}

final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);