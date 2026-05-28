import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journi/providers/freeze_provider.dart';
import 'package:journi/providers/time_service_provider.dart';
import 'package:journi/services/diary_service.dart';
import 'package:journi/utils/streak_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diary_entry.dart';
import '../services/notification_service.dart';
import '../types/streak_day.dart';
import '../types/streak_state.dart';

final allEntriesProvider = FutureProvider<List<DiaryEntry>>((ref) {
  return ref.read(diaryServiceProvider).getAllEntries();
  ;
});

final entryForDateProvider = FutureProvider.family<DiaryEntry?, DateTime>((
  ref,
  date,
) {
  return ref.read(diaryServiceProvider).getEntryByDate(date);
});

final streakDaysMapProvider = Provider<AsyncValue<Map<String, StreakDay>>>((
  ref,
) {
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

final streakStateProvider = Provider<AsyncValue<StreakState>>((ref) {
  final today = ref.watch(currentDateProvider);
  final diaryAsync = ref.watch(streakDaysMapProvider);
  final freezeAsync = ref.watch(freezeProvider);

  return diaryAsync.whenData((diaryMap) {
    final freeze = freezeAsync.valueOrNull;
    return computeStreakState(
      today: today,
      diaryMap: diaryMap,
      freezeUsedDates: freeze?.freezeUsedDates ?? {},
      freezesAvailable: freeze?.freezesAvailable ?? 2,
      daysWrittenAfterFreeze: freeze?.daysWrittenAfterFreeze ?? 0,
    );
  });
});

final calendarDaysProvider = Provider<AsyncValue<Map<String, StreakDay>>>((
  ref,
) {
  final diaryAsync = ref.watch(streakDaysMapProvider);
  final freezeAsync = ref.watch(freezeProvider);

  return diaryAsync.whenData((map) {
    final frozenDates = freezeAsync.valueOrNull?.freezeUsedDates ?? {};

    return {
      for (final e in map.entries)
        e.key: StreakDay(
          date: e.value.date,
          hasDiary: e.value.hasDiary,
          isFrozen: frozenDates.contains(e.key),
        ),
      for (final dateStr in frozenDates)
        if (!map.containsKey(dateStr))
          dateStr: StreakDay(
            date: DateTime.parse(dateStr),
            hasDiary: false,
            isFrozen: true,
          ),
    };
  });
});

class DiaryEntryNotifier extends FamilyAsyncNotifier<DiaryEntry?, DateTime> {
  @override
  Future<DiaryEntry?> build(DateTime date) async {
    return ref.read(diaryServiceProvider).getEntryByDate(date);
  }

  Future<void> save(String text) async {
    final date = arg;
    final current = state.valueOrNull;
    final isNew = current?.id == null;
    final now = DateTime.now();

    final entry = DiaryEntry(
      id: current?.id,
      date: date,
      text: text,
      updatedAt: now,
    );

    final saved = await ref.read(diaryServiceProvider).upsertEntry(entry);
    state = AsyncData(saved);

    if (isNew) {
      await ref.read(freezeProvider.notifier).recordWritingDay();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_entry_saved_at', now.millisecondsSinceEpoch);
      await NotificationService.rescheduleAfterEntry(savedAt: now);
    }
  }
}

final diaryEntryNotifierProvider =
    AsyncNotifierProviderFamily<DiaryEntryNotifier, DiaryEntry?, DateTime>(
      DiaryEntryNotifier.new,
    );
