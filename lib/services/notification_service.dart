// lib/services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  NotificationService() {
    _initialize();
  }

  void _initialize() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  Future<void> scheduleDailyNotification(TimeOfDay time) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    // Guardar el horario en Firestore
    await _firestore.collection('users').doc(user.uid).update({
      'horarioNotificacion': {
        'hora': time.hour,
        'minuto': time.minute,
      },
    });

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Registro de Ánimo',
      'Es hora de registrar tu ánimo diario.',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel_id',
          'Notificaciones Diarias',
          channelDescription: 'Notificaciones para registrar ánimo diariamente',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time, // Repite diariamente
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<TimeOfDay> getNotificationTime() async {
    final User? user = _auth.currentUser;
    if (user == null) return const TimeOfDay(hour: 20, minute: 0);

    DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('horarioNotificacion')) {
        final horario = data['horarioNotificacion'];
        return TimeOfDay(hour: horario['hora'], minute: horario['minuto']);
      }
    }

    // Por defecto 8 PM
    return const TimeOfDay(hour: 20, minute: 0);
  }
}
