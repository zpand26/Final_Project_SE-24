import 'package:northstars_final/models/alerts_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class AlertsPresenter {
  final AlarmManager _alarmManager;
  final Function(List<Alarm>) onAlarmsUpdated;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  AlertsPresenter(this._alarmManager, this.onAlarmsUpdated);

  void addAlarm(String title, DateTime time) {
    _alarmManager.addAlarm(title, time);
    onAlarmsUpdated(_alarmManager.getAlarms());
    _scheduleNotification(title, time); // Schedule the notification
  }


  void _scheduleNotification(String title, DateTime alarmTime) async {
    final now = DateTime.now();

    // Ensure the scheduled time is in the future
    if (alarmTime.isBefore(now)) {
      print("Error: The alarm time must be in the future.");
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      'alarm_channel_id',
      'Alarm Notifications',
      channelDescription: 'Channel for Alarm notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // Notification ID
        title,
        'It\'s time for your job interview!!',
        tz.TZDateTime.from(alarmTime, tz.local), // Ensure this time is correct
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Updated parameter
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
      print("Notification successfully scheduled.");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }


}