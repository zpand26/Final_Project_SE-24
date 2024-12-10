import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:northstars_final/models/alerts_model.dart';

class AlertsPage extends StatefulWidget {
  final Function(String title, DateTime time) onAddAlarm;
  final List<Alarm> alarms;

  AlertsPage({required this.onAddAlarm, required this.alarms});

  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final TextEditingController titleController = TextEditingController();

  Future<void> _selectDateTime() async {
    // Open Date Picker
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (selectedDate == null) {
      // User canceled date selection
      return;
    }

    // Open Time Picker
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) {
      // User canceled time selection
      return;
    }

    // Combine selected date and time into a DateTime object
    final alarmTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Validate alarm title
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an alarm title before setting.')),
      );
      return;
    }

    // Set the alarm
    widget.onAddAlarm(titleController.text, alarmTime);

    // Notify user
    final formattedTime = DateFormat('MMM d, yyyy hh:mm a').format(alarmTime);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alarm set for $formattedTime')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: _selectDateTime,
          child: Text('Set Alarm'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.alarms.length,
            itemBuilder: (_, index) {
              final alarm = widget.alarms[index];
              final formattedTime = DateFormat('MMM d, yyyy hh:mm a').format(alarm.time);
              return ListTile(
                title: Text(alarm.title),
                subtitle: Text(formattedTime),
              );
            },
          ),
        ),
      ],
    );
  }
}
