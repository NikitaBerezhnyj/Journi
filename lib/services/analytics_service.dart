import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static const _milestones = [7, 30, 100, 365];

  static Future<void> _log(
      String name, [
        Map<String, Object>? parameters,
      ]) async {
    if (kDebugMode) return;
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  static String _lengthBucket(int chars) {
    if (chars < 50) return 'short';
    if (chars < 300) return 'medium';
    return 'long';
  }

  static int? milestoneCrossed({required int previous, required int next}) {
    int? crossed;
    for (final m in _milestones) {
      if (previous < m && next >= m) crossed = m;
    }
    return crossed;
  }

  static Future<void> logEntryStarted({required bool isToday}) {
    return _log('diary_entry_started', {'is_today': isToday ? 1 : 0});
  }

  static Future<void> logEntrySaved({
    required int finalLength,
    required bool isToday,
    required bool isEdit,
  }) {
    if (finalLength == 0) return Future.value();
    return _log('diary_entry_saved', {
      'length_bucket': _lengthBucket(finalLength),
      'is_today': isToday ? 1 : 0,
      'is_edit': isEdit ? 1 : 0,
    });
  }

  static Future<void> logEntryAbandoned({
    required bool isToday,
    required bool hadPreviousText,
  }) {
    return _log('diary_entry_abandoned', {
      'is_today': isToday ? 1 : 0,
      'had_previous_text': hadPreviousText ? 1 : 0,
    });
  }

  static Future<void> logStreakBroken({
    required int streakLengthBeforeBreak,
  }) {
    if (streakLengthBeforeBreak == 0) return Future.value();
    return _log('streak_broken', {
      'streak_length_before_break': streakLengthBeforeBreak,
    });
  }

  static Future<void> logStreakMilestone({required int milestoneDays}) {
    return _log('streak_milestone_reached', {
      'milestone_days': milestoneDays,
    });
  }

  static Future<void> logFreezeUsed({required int remainingFreezes}) {
    return _log('streak_freeze_used', {
      'remaining_freezes': remainingFreezes,
    });
  }

  static Future<void> logFreezeRestored() {
    return _log('streak_freeze_restored');
  }

  static Future<void> logNotificationOpened({required String type}) {
    return _log('notification_opened', {'type': type});
  }

  static Future<void> logNotificationPermission({required bool granted}) {
    return _log('notification_permission_result', {
      'granted': granted ? 1 : 0,
    });
  }
}