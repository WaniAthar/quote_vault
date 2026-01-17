import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/quote.dart';
import '../services/quote_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final QuoteService _quoteService = QuoteService();

  static const String _notificationChannelId = 'daily_quote';
  static const String _notificationChannelName = 'Daily Quote';
  static const String _notificationChannelDescription =
      'Daily inspirational quote notifications';

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initializationSettings);

    // Request permission for Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleDailyQuoteNotification(TimeOfDay time) async {
    // Cancel existing notification first
    await cancelDailyQuoteNotification();

    try {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // If the time has already passed today, schedule for tomorrow
      var notificationTime = scheduledTime.isBefore(now)
          ? scheduledTime.add(const Duration(days: 1))
          : scheduledTime;

      print('Scheduling notification for: $notificationTime (Local)');
      print('Current time: $now');

      await _notifications.zonedSchedule(
        0, // notification id
        'Quote of the Day',
        'Tap to read your daily inspiration',
        tz.TZDateTime.from(notificationTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _notificationChannelId,
            _notificationChannelName,
            channelDescription: _notificationChannelDescription,
            importance: Importance.max, // Changed to Max
            priority: Priority.high,
            ticker: 'ticker',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
            DateTimeComponents.time, // Repeat daily at same time
      );

      // Save the scheduled time
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('notification_hour', time.hour);
      await prefs.setInt('notification_minute', time.minute);
    } catch (error) {
      // Handle error
    }
  }

  Future<void> cancelDailyQuoteNotification() async {
    await _notifications.cancel(0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notification_hour');
    await prefs.remove('notification_minute');
  }

  Future<TimeOfDay?> getScheduledNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('notification_hour');
    final minute = prefs.getInt('notification_minute');

    if (hour != null && minute != null) {
      return TimeOfDay(hour: hour, minute: minute);
    }
    return null;
  }

  Future<void> showQuoteNotification(Quote quote) async {
    await _notifications.show(
      1, // different id for immediate notifications
      'Quote of the Day',
      quote.text,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _notificationChannelId,
          _notificationChannelName,
          channelDescription: _notificationChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> showDailyQuoteNotification() async {
    try {
      final quote = await _quoteService.getQuoteOfTheDay();
      if (quote != null) {
        await showQuoteNotification(quote);
      }
    } catch (error) {
      // Handle error
    }
  }
}
