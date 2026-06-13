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

    int available = await getFreezesAvailable();
    final usedDates = await getFreezeUsedDates();
    int applied = 0;

    for (int i = 1; i <= gapDays; i++) {
      if (available <= 0) break;

      final day = lastWrittenDay.add(Duration(days: i));
      if (dateKey(day) == dateKey(today)) break;

      final dayKey = dateKey(day);
      if (usedDates.contains(dayKey)) continue;

      usedDates.add(dayKey);
      available--;
      applied++;
    }

    if (applied > 0) {
      await prefs.setStringList(_keyFreezeUsedDates, usedDates.toList());
      await prefs.setInt(_keyFreezesAvailable, available);
      await prefs.setInt(_keyDaysWrittenAfterFreeze, 0);
      return true;
    }

    return false;
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
