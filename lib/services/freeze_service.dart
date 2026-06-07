import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/date_utils.dart';

class FreezeService {
  static final FreezeService instance = FreezeService._();
  FreezeService._();

  static const _keyFreezesAvailable = 'freeze_available';
  static const _keyFreezeUsedDates = 'freeze_used_dates';
  static const _keyDaysWrittenAfterFreeze = 'freeze_days_written_after';

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

  Future<bool> applyFreezeIfNeeded({
    required DateTime today,
    required Map<String, bool> diaryMap,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    DateTime? lastWrittenDay;
    for (int daysBack = 1; daysBack <= 60; daysBack++) {
      final day = today.subtract(Duration(days: daysBack));
      final key = dateKey(day);
      if (diaryMap[key] == true) {
        lastWrittenDay = day;
        break;
      }
    }

    if (lastWrittenDay == null) return false;

    final gapDays = today.difference(lastWrittenDay).inDays - 1;

    if (gapDays <= 0) return false;

    final available = await getFreezesAvailable();

    if (gapDays > available) {
      final currentMax = prefs.getInt(_keyFreezesAvailable) ?? maxFreezes;
      if (currentMax == maxFreezes) return false;
      await prefs.setInt(_keyFreezesAvailable, maxFreezes);
      await prefs.setInt(_keyDaysWrittenAfterFreeze, 0);
      return true;
    }

    int applied = 0;

    for (int i = 1; i <= gapDays; i++) {
      final day = lastWrittenDay.add(Duration(days: i));
      final dayKey = dateKey(day);

      if (dayKey == dateKey(today)) break;

      final usedDates = await getFreezeUsedDates();
      if (usedDates.contains(dayKey)) continue;

      final currentAvailable = await getFreezesAvailable();
      if (currentAvailable <= 0) break;

      final newUsedDates = {...usedDates, dayKey};
      await prefs.setStringList(_keyFreezeUsedDates, newUsedDates.toList());
      await prefs.setInt(_keyFreezesAvailable, currentAvailable - 1);
      await prefs.setInt(_keyDaysWrittenAfterFreeze, 0);
      applied++;
    }

    return applied > 0;
  }

  Future<void> recordWritingDay() async {
    final prefs = await SharedPreferences.getInstance();
    final available = prefs.getInt(_keyFreezesAvailable) ?? maxFreezes;

    if (available >= maxFreezes) return;

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
