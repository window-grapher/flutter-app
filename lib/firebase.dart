import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'alarm.dart';
import 'notification.dart';

void handleMessage(Function(String, String) onMessage) async {
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
    print(
        "message has come on foreground. ${message.data["title"]}: ${message.data["body"]}");
    onMessage(message.data["title"], message.data["body"]);
    // FlutterRingtonePlayer().playAlarm();
  });
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(
      "message has come on background. ${message.data["title"]}: ${message.data["body"]}");
  LocalNotification().show(message.data["title"], message.data["body"]);
  // FlutterRingtonePlayer().playAlarm();

  // Enable to stop alarm.
  ReceivePort receiver = ReceivePort();
  IsolateNameServer.registerPortWithName(receiver.sendPort, portName);
  receiver.listen((message) async {
    if (message == "stop") {
      await FlutterRingtonePlayer().stop();
    }
  });
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
