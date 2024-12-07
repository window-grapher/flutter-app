import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  final channel = const AndroidNotificationChannel(
    'id',
    'notification_channel',
    importance: Importance.high,
    playSound: false,
  );

  final flutterLocalNotifications = FlutterLocalNotificationsPlugin();

  LocalNotification() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));
    flutterLocalNotifications
      ..resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission()
      ..initialize(const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings()));
  }

  show(String title, String message) {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: channel.importance,
        playSound: false,
        fullScreenIntent: true,
      ),
    );

    flutterLocalNotifications.show(
      1,
      title,
      message,
      notificationDetails,
    );
  }
}
