import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../providers/shared_prefs_provider.dart';
import '../services/database_service.dart';
import '../utils/date_utils.dart';

class FreezeService {
  FreezeService(this._prefs);

  final SharedPreferences _prefs;

  static const int maxFreezes = 2;
  static const int daysToRestore = 3;

  static const _keyFreezesAvailable = 'freeze_available';
  static const _keyDaysWrittenAfterFreeze = 'freeze_days_written_after';

  int getFreezesAvailable() =>
      _prefs.getInt(_keyFreezesAvailable) ?? maxFreezes;

  int getDaysWrittenAfterFreeze() =>
      _prefs.getInt(_keyDaysWrittenAfterFreeze) ?? 0;

  Future<Set<String>> getFreezeUsedDates() async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query('freeze_days');
    return rows.map((r) => r['date'] as String).toSet();
  }

  Future<bool> applyFreezeIfNeeded({
    required DateTime today,
    required Map<String, bool> diaryMap,
  }) async {
    final db = await DatabaseService.instance.database;
    final usedDates = await getFreezeUsedDates();
    int available = getFreezesAvailable();

    DateTime? lastWrittenDay;
    for (int i = 1; i <= 365; i++) {
      final day = today.subtract(Duration(days: i));
      if (diaryMap[dateKey(day)] == true) {
        lastWrittenDay = day;
        break;
      }
    }

    if (lastWrittenDay == null) return false;

    final gapDays = today.difference(lastWrittenDay).inDays - 1;

    if (gapDays <= 0) return false;

    if (gapDays > available) return false;

    int applied = 0;
    for (int i = 1; i <= gapDays; i++) {
      final day = lastWrittenDay.add(Duration(days: i));
      final key = dateKey(day);
      if (usedDates.contains(key)) continue;

      await db.insert('freeze_days', {
        'date': key,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      available--;
      applied++;
    }

    if (applied > 0) {
      _prefs.setInt(_keyFreezesAvailable, available);
      _prefs.setInt(_keyDaysWrittenAfterFreeze, 0);
      return true;
    }

    return false;
  }

  Future<void> recordWritingDay() async {
    final available = getFreezesAvailable();

    if (available >= maxFreezes) {
      _prefs.setInt(_keyDaysWrittenAfterFreeze, 0);
      return;
    }

    final current = getDaysWrittenAfterFreeze();
    final next = current + 1;

    if (next >= daysToRestore) {
      _prefs.setInt(_keyFreezesAvailable, available + 1);
      _prefs.setInt(_keyDaysWrittenAfterFreeze, 0);
    } else {
      _prefs.setInt(_keyDaysWrittenAfterFreeze, next);
    }
  }

  Future<void> restoreFreezesIfNeeded() async {
    final available = getFreezesAvailable();
    if (available >= maxFreezes) return;
    _prefs.setInt(_keyFreezesAvailable, maxFreezes);
    _prefs.setInt(_keyDaysWrittenAfterFreeze, 0);
  }
}

final freezeServiceProvider = Provider<FreezeService>((ref) {
  return FreezeService(ref.read(sharedPrefsProvider));
});
