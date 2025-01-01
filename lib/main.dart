import 'dart:async';

import 'package:alarm/firebase.dart';
import 'package:alarm/permission.dart';
import 'package:alarm/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'MainWebView.dart';
import 'alarm.dart';
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

  // Handle foreground message.
  handleMessage((title, message) => {LocalNotification().show(title, message)});
  // Handle background message.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(ProviderScope(
    child: MaterialApp(
      home: MyApp(fcmToken ?? "", deviceId),
    ),
  ));
}

class MyApp extends ConsumerWidget {
  final String fcmToken;
  final String deviceId; // 追加

  const MyApp(this.fcmToken, this.deviceId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        home: PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              ref.watch(webViewNotifierProvider).webViewController?.goBack();
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('ぽいくる'),
              ),
              body: WebView(fcmToken, deviceId),
              floatingActionButton: const StopAlarmButton(),
            )));
  }
}
