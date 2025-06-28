import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata; // atau latest.dart
import 'package:timezone/timezone.dart' as tz;

class NotifServices {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> init() async {
    // Inisialisasi timezone
    tzdata.initializeTimeZones();

    final String localTimeZone = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(localTimeZone));

    const androidsettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    final InitializationSettings settings =
        InitializationSettings(android: androidsettings, iOS: iosSettings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> scheduledNotification(
      {required int id,
      required String title,
      required String body,
      required TZDateTime scheduledDate}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'todos_reminder_channel_id', 'Todos Reminder',
              icon: '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high),
          iOS: DarwinNotificationDetails()),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
    debugPrint("Now: ${DateTime.now()}");
    debugPrint("Scheduled: $scheduledDate");
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
