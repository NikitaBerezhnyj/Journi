import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_service.dart';

class LocaleNotifier extends AsyncNotifier<Locale?> {
  @override
  Future<Locale> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('locale');

    if (saved != null) {
      return Locale(saved);
    }

    const supported = ['uk', 'es', 'en'];
    final systemCode = PlatformDispatcher.instance.locale.languageCode;
    final resolved = supported.contains(systemCode) ? systemCode : 'en';

    await prefs.setString('locale', resolved);

    return Locale(resolved);
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    final oldLocale = prefs.getString('locale');

    if (oldLocale == locale.languageCode) return;

    await prefs.setString('locale', locale.languageCode);

    state = AsyncData(locale);

    final lastSavedMillis = prefs.getInt('last_entry_saved_at');
    if (lastSavedMillis != null) {
      await NotificationService.rescheduleLocale(
        lastSavedAt: DateTime.fromMillisecondsSinceEpoch(lastSavedMillis),
      );
    }
  }
}

final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);