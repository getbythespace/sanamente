// lib/widgets/notification_schedule.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';

class NotificationSchedule extends StatefulWidget {
  const NotificationSchedule({Key? key}) : super(key: key);

  @override
  _NotificationScheduleState createState() => _NotificationScheduleState();
}

class _NotificationScheduleState extends State<NotificationSchedule> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadNotificationTime();
  }

  void _loadNotificationTime() async {
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    TimeOfDay time = await notificationService.getNotificationTime();
    setState(() {
      _selectedTime = time;
    });
  }

  void _editNotificationTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 20, minute: 0),
    );

    if (picked != null && picked != _selectedTime) {
      final notificationService = Provider.of<NotificationService>(context, listen: false);
      await notificationService.scheduleDailyNotification(picked);
      setState(() {
        _selectedTime = picked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Horario de notificación actualizado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String timeText = _selectedTime != null
        ? _selectedTime!.format(context)
        : 'No configurado';

    return Card(
      elevation: 4,
      child: ListTile(
        title: const Text('Horario de Notificaciones'),
        subtitle: Text(timeText),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _editNotificationTime,
        ),
      ),
    );
  }
}
