import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Alarm {
  String title;
  DateTime time;

  Alarm({required this.title, required this.time});

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      title: json['title'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'time': time.toIso8601String(),
  };
}

class AlarmManager {
  List<Alarm> alarms = [];

  Future<void> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAlarms = prefs.getString('alarms');
    if (savedAlarms != null) {
      alarms = (jsonDecode(savedAlarms) as List)
          .map((e) => Alarm.fromJson(e))
          .toList();
    }
  }

  Future<void> saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'alarms',
      jsonEncode(alarms.map((e) => e.toJson()).toList()),
    );
  }

  void addAlarm(String title, DateTime time) {
    alarms.add(Alarm(title: title, time: time));
    saveAlarms();
  }

  List<Alarm> getAlarms() => alarms;
}
