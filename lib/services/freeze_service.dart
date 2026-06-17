import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/date_utils.dart';

class FreezeService {
  static final FreezeService instance = FreezeService._();
  FreezeService._();

  static const _keyFreezesAvailable = 'freeze_available';
  static const _keyFreezeUsedDates = 'freeze_used_dates';
  static const _keyDaysWrittenAfterFreeze = 'freeze_days_written_after';
  static const _keyCurrentStreakStart = 'current_streak_start';

  static const int maxFreezes = 2;
  static const int daysToRestore = 3;

  Future<int> getFreezesAvailable() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyFreezesAvailable) ?? maxFreezes;
  }

  Future<Set<String>> getFreezeUsedDates() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyFreezeUsedDates) ?? [];
    return raw.toSet();
  }

  Future<int> getDaysWrittenAfterFreeze() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyDaysWrittenAfterFreeze) ?? 0;
  }

  Future<String?> getCurrentStreakStart() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrentStreakStart);
  }

  DateTime? _findCurrentStreakStart({
    required DateTime today,
    required Map<String, bool> diaryMap,
    required Set<String> usedDates,
  }) {
    final todayKey = dateKey(today);
    final yesterdayKey = dateKey(today.subtract(const Duration(days: 1)));
    final hasToday = diaryMap[todayKey] == true;
    final hasYesterday = diaryMap[yesterdayKey] == true ||
        usedDates.contains(yesterdayKey);

    if (!hasToday && !hasYesterday) return null;

    DateTime current = hasToday
        ? today
        : today.subtract(const Duration(days: 1));

    DateTime? streakStart;
    while (true) {
      final key = dateKey(current);
      final hasDiary = diaryMap[key] == true;
      final isFrozen = usedDates.contains(key);
      if (hasDiary || isFrozen) {
        if (hasDiary) streakStart = current;
        current = current.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streakStart;
  }

  Future<bool> applyFreezeIfNeeded({
    required DateTime today,
    required Map<String, bool> diaryMap,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final usedDates = await getFreezeUsedDates();
    int available = await getFreezesAvailable();

    final todayKey = dateKey(today);
    final savedStreakStartStr = await getCurrentStreakStart();
    final savedStreakStart = savedStreakStartStr != null
        ? DateTime.tryParse(savedStreakStartStr)
        : null;

    DateTime? lastWrittenDay;
    for (int daysBack = 1; daysBack <= 365; daysBack++) {
      final day = today.subtract(Duration(days: daysBack));
      if (diaryMap[dateKey(day)] == true) {
        lastWrittenDay = day;
        break;
      }
    }

    final gapDays = lastWrittenDay != null
        ? today.difference(lastWrittenDay).inDays - 1
        : -1;

    final gapIsCoverable = gapDays >= 0 &&
        gapDays <= available &&
        (savedStreakStart != null &&
            !lastWrittenDay!.isBefore(savedStreakStart));

    if (!gapIsCoverable) {
      if (savedStreakStart != null) {
        await _resetForNewStreak(prefs);
        return true;
      }

      return false;
    }

    int applied = 0;
    for (int i = 1; i <= gapDays; i++) {
      if (available <= 0) break;
      final day = lastWrittenDay.add(Duration(days: i));
      if (dateKey(day) == todayKey) break;
      final dayKey = dateKey(day);
      if (usedDates.contains(dayKey)) continue;
      usedDates.add(dayKey);
      available--;
      applied++;
    }

    final currentStart = _findCurrentStreakStart(
      today: today,
      diaryMap: diaryMap,
      usedDates: usedDates,
    );
    if (currentStart != null) {
      await prefs.setString(_keyCurrentStreakStart, dateKey(currentStart));
    }

    if (applied > 0) {
      await prefs.setStringList(_keyFreezeUsedDates, usedDates.toList());
      await prefs.setInt(_keyFreezesAvailable, available);
      await prefs.setInt(_keyDaysWrittenAfterFreeze, 0);
      return true;
    }

    if (currentStart != null && savedStreakStartStr != dateKey(currentStart)) {
      await prefs.setString(_keyCurrentStreakStart, dateKey(currentStart));
      return true;
    }

    return false;
  }

  Future<void> _resetForNewStreak(SharedPreferences prefs) async {
    await prefs.setInt(_keyFreezesAvailable, maxFreezes);
    await prefs.setInt(_keyDaysWrittenAfterFreeze, 0);
    await prefs.remove(_keyCurrentStreakStart);
    await prefs.setStringList(_keyFreezeUsedDates, []);
  }

  Future<void> recordWritingDay() async {
    final prefs = await SharedPreferences.getInstance();
    final available = prefs.getInt(_keyFreezesAvailable) ?? maxFreezes;

    if (available >= maxFreezes) {
      await prefs.setInt(_keyDaysWrittenAfterFreeze, 0);
      return;
    }

    final current = prefs.getInt(_keyDaysWrittenAfterFreeze) ?? 0;
    final next = current + 1;

    if (next >= daysToRestore) {
      await prefs.setInt(_keyFreezesAvailable, available + 1);
      await prefs.setInt(_keyDaysWrittenAfterFreeze, 0);
    } else {
      await prefs.setInt(_keyDaysWrittenAfterFreeze, next);
    }
  }
}

final freezeServiceProvider = Provider<FreezeService>((ref) {
  return FreezeService.instance;
});