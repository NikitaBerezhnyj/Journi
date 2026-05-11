import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journi/providers/time_service_provider.dart';
import 'package:journi/services/diary_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diary_entry.dart';
import '../services/notification_service.dart';
import '../types/streak_day.dart';

final allEntriesProvider = FutureProvider<List<DiaryEntry>>((ref) {
  return DiaryService.instance.getAllEntries();
});

final entryForDateProvider =
FutureProvider.family<DiaryEntry?, DateTime>((ref, date) {
  return DiaryService.instance.getEntryByDate(date);
});

final streakDaysMapProvider =
Provider<AsyncValue<Map<String, StreakDay>>>((ref) {
  return ref.watch(allEntriesProvider).whenData((entries) {
    return {
      for (final e in entries)
        e.date.toIso8601String().substring(0, 10): StreakDay(
          date: e.date,
          hasDiary: e.text.trim().isNotEmpty,
        ),
    };
  });
});

final last7DaysProvider = Provider<AsyncValue<List<StreakDay>>>((ref) {
  final today = ref.watch(currentDateProvider);

  return ref.watch(streakDaysMapProvider).whenData((map) {
    return List.generate(7, (i) {
      final date = today.subtract(Duration(days: 6 - i));
      final key = date.toIso8601String().substring(0, 10);
      return map[key] ?? StreakDay(date: date, hasDiary: false);
    });
  });
});

final streakCountProvider = Provider<AsyncValue<int>>((ref) {
  final today = ref.watch(currentDateProvider);

  return ref.watch(streakDaysMapProvider).whenData((map) {
    int streak = 0;

    final todayKey = today.toIso8601String().substring(0, 10);
    final hasToday = map[todayKey]?.hasDiary ?? false;

    DateTime current = hasToday
        ? today
        : today.subtract(const Duration(days: 1));

    while (true) {
      final key = current.toIso8601String().substring(0, 10);
      final entry = map[key];

      if (entry == null || !entry.hasDiary) break;

      streak++;
      current = current.subtract(const Duration(days: 1));
    }

    return streak;
  });
});

class DiaryEntryNotifier extends AsyncNotifier<DiaryEntry?> {
  late DateTime _date;

  void setDate(DateTime date) {
    _date = date;
  }

  @override
  Future<DiaryEntry?> build() async {
    return null;
  }

  Future<void> loadForDate(DateTime date) async {
    _date = date;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
          () => DiaryService.instance.getEntryByDate(date),
    );
  }

  Future<void> save(String text) async {
    final current = state.valueOrNull;
    final isNew = current?.id == null;
    final now = DateTime.now();

    final entry = DiaryEntry(
      id: current?.id,
      date: _date,
      text: text,
      updatedAt: now,
    );

    final saved = await DiaryService.instance.upsertEntry(entry);
    state = AsyncData(saved);

    if (isNew) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_entry_saved_at', now.millisecondsSinceEpoch);

      await NotificationService.rescheduleAfterEntry(savedAt: now);
    }
  }
}

final diaryEntryNotifierProvider =
AsyncNotifierProvider<DiaryEntryNotifier, DiaryEntry?>(
  DiaryEntryNotifier.new,
);