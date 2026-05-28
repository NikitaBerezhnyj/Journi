import '../types/streak_day.dart';
import '../types/streak_state.dart';
import '../services/freeze_service.dart';
import 'date_utils.dart';

StreakState computeStreakState({
  required DateTime today,
  required Map<String, StreakDay> diaryMap,
  required Set<String> freezeUsedDates,
  required int freezesAvailable,
  required int daysWrittenAfterFreeze,
}) {
  int streak = 0;
  DateTime current = today;
  final todayKey = dateKey(today);
  final hasToday = diaryMap[todayKey]?.hasDiary ?? false;

  if (!hasToday) {
    current = today.subtract(const Duration(days: 1));
  }

  while (true) {
    final key = dateKey(current);
    final hasDiary = diaryMap[key]?.hasDiary ?? false;
    final isFrozen = freezeUsedDates.contains(key);

    if (hasDiary) {
      streak++;
    } else if (isFrozen) {
    } else {
      break;
    }

    current = current.subtract(const Duration(days: 1));
  }

  final last7 = List.generate(7, (i) {
    final date = today.subtract(Duration(days: 6 - i));
    final key = dateKey(date);
    final base = diaryMap[key] ?? StreakDay(date: date, hasDiary: false);
    return StreakDay(
      date: base.date,
      hasDiary: base.hasDiary,
      isFrozen: freezeUsedDates.contains(key),
    );
  });

  return StreakState(
    streakCount: streak,
    freezesAvailable: freezesAvailable,
    daysWrittenAfterFreeze: daysWrittenAfterFreeze,
    daysToRestoreFreeze: FreezeService.daysToRestore,
    last7Days: last7,
  );
}
