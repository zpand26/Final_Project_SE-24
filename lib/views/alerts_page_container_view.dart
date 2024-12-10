import 'package:flutter/material.dart';
import 'package:northstars_final/models/alerts_model.dart';
import 'package:northstars_final/presenters/alerts_presenter.dart';
import 'alerts_page_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class AlertsPageContainer extends StatefulWidget {
  @override
  _AlertsPageContainerState createState() => _AlertsPageContainerState();
}

class _AlertsPageContainerState extends State<AlertsPageContainer> {
  late AlertsPresenter _presenter;
  List<Alarm> _alarms = [];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();

    final alarmManager = AlarmManager();

    alarmManager.loadAlarms().then((_) {
      _presenter = AlertsPresenter(alarmManager, (updatedAlarms) {
        setState(() {
          _alarms = updatedAlarms;
        });
      });

      setState(() {
        _alarms = alarmManager.getAlarms();
      });
    });
  }

  void _initializeNotifications() {
    const androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    tz.initializeTimeZones(); // Initialize timezone data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alerts')),
      body: AlertsPage(
        onAddAlarm: (title, time) {
          _presenter.addAlarm(title, time);
        },
        alarms: _alarms,
      ),
    );
  }
}
