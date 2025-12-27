import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  static const int _feedReminderId = 1001;
  static const int _snoozeId = 1002;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzdata.initializeTimeZones();
    // Default to local time zone; Android runner uses device tz.
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: android);
    await _plugin.initialize(initSettings);
  }

  Future<void> cancelAll() async {
    await _plugin.cancel(_feedReminderId);
    await _plugin.cancel(_snoozeId);
  }

  Future<void> scheduleNextFeedReminder({required int intervalHours}) async {
    await _plugin.cancel(_feedReminderId);

    final now = tz.TZDateTime.now(tz.local);
    final scheduled = now.add(Duration(hours: intervalHours));

    const androidDetails = AndroidNotificationDetails(
      'feed_reminders',
      'Feed reminders',
      channelDescription: 'Podsetnici za hranjenje',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    await _plugin.zonedSchedule(
      _feedReminderId,
      'Podsetnik: hranjenje',
      'Vreme je da proveriš hranjenje (na $intervalHours h).',
      scheduled,
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> snooze({required int minutes}) async {
    await _plugin.cancel(_snoozeId);
    final now = tz.TZDateTime.now(tz.local);
    final scheduled = now.add(Duration(minutes: minutes));

    const androidDetails = AndroidNotificationDetails(
      'feed_snooze',
      'Feed snooze',
      channelDescription: 'Snooze podsetnici',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    await _plugin.zonedSchedule(
      _snoozeId,
      'Snooze: hranjenje',
      'Podsetnik za $minutes min.',
      scheduled,
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
