import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification.dart';

import 'package:firebase_core/firebase_core.dart';


void handleMessage(Function(String) onMessage) async {
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.

  }).onError((err) {
    // Error getting token.
  });

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("foreground. ${message.notification?.body}");
    onMessage(message.notification?.body ?? "");
  });
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("message has come on background. : ${message.notification?.body}");
  LocalNotification().show("background", message.notification?.body ?? "");
}

Future<String?> getDeviceToken() async {
  String? token;
  if (Platform.isIOS) {
    token = await FirebaseMessaging.instance.getAPNSToken();
  } else {
    token = await FirebaseMessaging.instance.getToken();
  }
  return token;
}