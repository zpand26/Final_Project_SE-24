class Alarm {
  String title;
  DateTime time;

  Alarm({required this.title, required this.time});
}

class AlarmManager {
  List<Alarm> alarms = [];

  void addAlarm(String title, DateTime time) {
    alarms.add(Alarm(title: title, time: time));
  }

  List<Alarm> getAlarms() => alarms;
}
