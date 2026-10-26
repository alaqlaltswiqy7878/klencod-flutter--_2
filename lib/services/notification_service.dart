import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/task.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();
  final plugin = FlutterLocalNotificationsPlugin();
  bool enabled = true;
  Future<void> init() async { tz.initializeTimeZones(); const android = AndroidInitializationSettings('@mipmap/ic_launcher'); await plugin.initialize(const InitializationSettings(android: android)); final a = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>(); await a?.requestNotificationsPermission(); }
  Future<void> schedule(DailyTask task) async { if (!enabled || task.id == null || task.timeMinutes == null || task.text.trim().isEmpty) return; final now = tz.TZDateTime.now(tz.local); final base = DateTime.parse(task.date); var when = tz.TZDateTime(tz.local, base.year, base.month, base.day, task.timeMinutes! ~/ 60, task.timeMinutes! % 60); if (when.isBefore(now)) return; await plugin.zonedSchedule(task.id!, 'تذكير بالمهمة', task.text.trim(), when, const NotificationDetails(android: AndroidNotificationDetails('daily_tasks', 'تذكيرات المهام', channelDescription: 'تنبيهات أوقات المهام اليومية', importance: Importance.high, priority: Priority.high)), androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime); }
  Future<void> cancel(int id) => plugin.cancel(id);
}
