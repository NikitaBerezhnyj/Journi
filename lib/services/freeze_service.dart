import 'package:shared_preferences/shared_preferences.dart';

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

  Future<int> applyFreezeIfNeeded({
    required DateTime today,
    required Map<String, bool> diaryMap,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    int applied = 0;

    for (int daysBack = 1; daysBack <= 7; daysBack++) {
      final day = today.subtract(Duration(days: daysBack));
      final dayKey = _dateKey(day);

      if (diaryMap[dayKey] == true) break;

      final usedDates = await getFreezeUsedDates();

      if (usedDates.contains(dayKey)) continue;

      final available = await getFreezesAvailable();

      if (available <= 0) break;

      final newUsedDates = {...usedDates, dayKey};
      await prefs.setStringList(_keyFreezeUsedDates, newUsedDates.toList());
      await prefs.setInt(_keyFreezesAvailable, available - 1);
      await prefs.setInt(_keyDaysWrittenAfterFreeze, 0);
      applied++;
    }

    return applied;
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

String _dateKey(DateTime date) => date.toIso8601String().substring(0, 10);
