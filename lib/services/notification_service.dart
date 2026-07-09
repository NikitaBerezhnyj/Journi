import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../constants/notification_strings.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'journi_reminders';
  static const _id24h = 1;
  static const _idEvening = 2;
  static const _idFreezeWarning = 3;
  static const _idStreakLost = 4;

  static const int _defaultEveningHour = 21;
  static const int _defaultEveningMinute = 0;

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    String localTimezone = await FlutterTimezone.getLocalTimezone();
    if (localTimezone == 'Europe/Kiev') localTimezone = 'Europe/Kyiv';
    try {
      tz.setLocalLocation(tz.getLocation(localTimezone));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    const android = AndroidInitializationSettings('@drawable/ic_notification');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> rescheduleAfterEntry({
    required DateTime savedAt,
    required int freezesAvailable,
    required SharedPreferences prefs,
  }) async {
    final enabled = prefs.getBool('reminders_enabled') ?? true;
    if (!enabled) return;

    final locale = prefs.getString('locale') ?? 'uk';

    await _scheduleAll(
      savedAt: savedAt,
      locale: locale,
      freezesAvailable: freezesAvailable,
    );
  }

  static Future<void> rescheduleLocale({
    required DateTime lastSavedAt,
    required int freezesAvailable,
    required SharedPreferences prefs,
  }) async {
    final pending = await _plugin.pendingNotificationRequests();
    if (pending.isEmpty) return;
    await rescheduleAfterEntry(
      savedAt: lastSavedAt,
      freezesAvailable: freezesAvailable,
      prefs: prefs,
    );
  }

  static Future<void> _scheduleAll({
    required DateTime savedAt,
    required String locale,
    required int freezesAvailable,
  }) async {
    await _plugin.cancelAll();

    await _scheduleIfFuture(
      id: _id24h,
      title: NotificationStrings.get('reminder24hTitle', locale),
      body: NotificationStrings.get('reminder24hBody', locale),
      scheduledDate: savedAt.add(const Duration(hours: 24)),
      locale: locale,
    );

    await _scheduleIfFuture(
      id: _idEvening,
      title: NotificationStrings.get('reminderEveningTitle', locale),
      body: NotificationStrings.get('reminderEveningBody', locale),
      scheduledDate: _nextEvening(
        savedAt,
        _defaultEveningHour,
        _defaultEveningMinute,
      ),
      locale: locale,
    );

    if (freezesAvailable > 0) {
      final freezeWarningDay = savedAt.add(Duration(days: freezesAvailable));
      await _scheduleIfFuture(
        id: _idFreezeWarning,
        title: NotificationStrings.get('reminderFreezeWarningTitle', locale),
        body: NotificationStrings.get('reminderFreezeWarningBody', locale),
        scheduledDate: _nextEvening(
          freezeWarningDay.subtract(const Duration(days: 1)),
          _defaultEveningHour,
          _defaultEveningMinute,
        ),
        locale: locale,
      );
    }

    await _scheduleIfFuture(
      id: _idStreakLost,
      title: NotificationStrings.get('reminderStreakLostTitle', locale),
      body: NotificationStrings.get('reminderStreakLostBody', locale),
      scheduledDate: savedAt.add(Duration(days: freezesAvailable + 2)),
      locale: locale,
    );
  }

  static Future<void> _scheduleIfFuture({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String locale,
  }) async {
    final now = DateTime.now();
    if (scheduledDate.isBefore(now)) return;
    final channelName = NotificationStrings.get('channelName', locale);
    final channelDesc = NotificationStrings.get('channelDescription', locale);
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          channelName,
          channelDescription: channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static DateTime _nextEvening(DateTime savedAt, int hour, int minute) {
    final nextDay = DateTime(savedAt.year, savedAt.month, savedAt.day + 1);
    return DateTime(nextDay.year, nextDay.month, nextDay.day, hour, minute);
  }
}
