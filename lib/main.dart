import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:alarm/firebase.dart';
import 'package:alarm/permission.dart';
import 'package:alarm/provider.dart';
import 'package:alarm/ui/alarm_settings_drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'alarm.dart';
import 'ui/main_webview.dart';
import 'firebase_options.dart';

import 'notification.dart';
import 'device_id.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await getDeviceToken();
  final deviceId = await DeviceIdManager.getDeviceId();

  print("FCM Token: $fcmToken");
  print("Device ID: $deviceId");

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: MaterialApp(
      home: MyApp(fcmToken ?? "", deviceId),
    ),
  ));

  // Handle foreground message.
  handleMessage((RemoteMessage message) async {
    print(
        "message has come on foreground. ${message.data["title"]}: ${message.data["body"]}");
    LocalNotification().show(message.data["title"], message.data["body"]);
    startAlarm();
  });
  // Handle background message.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

class MyApp extends ConsumerWidget {
  final String fcmToken;
  final String deviceId;

  const MyApp(this.fcmToken, this.deviceId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: MaterialApp(
          home: PopScope(
              canPop: false,
              onPopInvoked: (didPop) async {
                ref.watch(webViewNotifierProvider).webViewController?.goBack();
              },
              child: Scaffold(
                drawer: const AlarmSettingsDrawer(),
                appBar: AppBar(
                  title: const Text('ぽいくる'),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(color: Colors.black87),
                                children: [
                                  TextSpan(text: 'やんばる急行バス様\n'),
                                  TextSpan(text: '実証実験'),
                                ],
                              ))),
                      const Tab(
                          child: Text('複数事業者対応版',
                              style: TextStyle(color: Colors.black87))),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    WebView(fcmToken, deviceId,
                        "https://window-grapher-yanbaru-express.app.takoyaki3.com"),
                    WebView(fcmToken, deviceId,
                        "https://dev.poicle.window-grapher.com"),
                  ],
                ),
                floatingActionButton: const StopAlarmButton(),
              ))),
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(
      "message has come on background. ${message.data["title"]}: ${message.data["body"]}");
  LocalNotification().show(message.data["title"], message.data["body"]);
  startAlarm();

  // Enable to stop alarm.
  ReceivePort receiver = ReceivePort();
  IsolateNameServer.registerPortWithName(receiver.sendPort, portName);
  receiver.listen((message) async {
    if (message == "stop") {
      stopAlarm();
    }
  });
}
