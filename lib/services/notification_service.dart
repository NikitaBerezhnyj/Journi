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
  static const _idStreak = 3;
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

    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static Future<void> rescheduleAfterEntry({
    required DateTime savedAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('reminders_enabled') ?? true;
    if (!enabled) return;

    final locale = prefs.getString('locale') ?? 'uk';

    await _scheduleAll(
      savedAt: savedAt,
      locale: locale,
    );
  }

  static Future<void> rescheduleLocale({
    required DateTime lastSavedAt,
  }) async {
    final pending = await _plugin.pendingNotificationRequests();
    if (pending.isEmpty) return;

    await rescheduleAfterEntry(savedAt: lastSavedAt);
  }

  static Future<void> _scheduleAll({
    required DateTime savedAt,
    required String locale,
  }) async {
    await _plugin.cancelAll();

    await _scheduleIfFuture(
      id: _id24h,
      title: NotificationStrings.get('reminder24hTitle', locale),
      body: NotificationStrings.get('reminder24hBody', locale),
      scheduledDate: savedAt.add(const Duration(hours: 24)),
      channelName: NotificationStrings.get('channelName', locale),
      channelDescription: NotificationStrings.get('channelDescription', locale),
    );

    await _scheduleIfFuture(
      id: _idEvening,
      title: NotificationStrings.get('reminderEveningTitle', locale),
      body: NotificationStrings.get('reminderEveningBody', locale),
      scheduledDate: _nextEvening(savedAt, _defaultEveningHour, _defaultEveningMinute),
      channelName: NotificationStrings.get('channelName', locale),
      channelDescription: NotificationStrings.get('channelDescription', locale),
    );

    await _scheduleIfFuture(
      id: _idStreak,
      title: NotificationStrings.get('reminderStreakTitle', locale),
      body: NotificationStrings.get('reminderStreakBody', locale),
      scheduledDate: savedAt.add(const Duration(days: 3)),
      channelName: NotificationStrings.get('channelName', locale),
      channelDescription: NotificationStrings.get('channelDescription', locale),
    );
  }

  static Future<void> _scheduleIfFuture({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String channelName,
    required String channelDescription,
  }) async {
    final now = DateTime.now();

    if (scheduledDate.isBefore(now)) {
      scheduledDate = now.add(const Duration(minutes: 1));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          channelName,
          channelDescription: channelDescription,
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

  static DateTime _nextEvening(
      DateTime savedAt,
      int hour,
      int minute,
      ) {
    final nextDay = DateTime(
      savedAt.year,
      savedAt.month,
      savedAt.day + 1,
    );

    return DateTime(
      nextDay.year,
      nextDay.month,
      nextDay.day,
      hour,
      minute,
    );
  }
}