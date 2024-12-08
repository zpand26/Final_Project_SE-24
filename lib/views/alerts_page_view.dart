import 'package:flutter/material.dart';
import 'package:northstars_final/models/alerts_model.dart';

class AlertsPage extends StatelessWidget {
  final Function(String title, DateTime time) onAddAlarm;
  final List<Alarm> alarms;

  AlertsPage({required this.onAddAlarm, required this.alarms});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Alarm Title'),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: selectedTime,
            );
            if (pickedTime != null) {
              selectedTime = pickedTime;
              var alarmTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                selectedTime.hour,
                selectedTime.minute,
              );


              onAddAlarm(titleController.text, alarmTime);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Alarm set for $alarmTime')),
              );
            }
          },
          child: Text('Set Alarm Time'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: alarms.length,
            itemBuilder: (_, index) {
              final alarm = alarms[index];
              return ListTile(
                title: Text(alarm.title),
                subtitle: Text(alarm.time.toString()),
              );
            },
          ),
        ),
      ],
    );
  }
}
