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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await getDeviceToken();
  print("token: $fcmToken");
  // TODO: Register fcmToken.

  // Handle foreground message.
  handleMessage((message) => {LocalNotification().show("foreground", message)});
  // Handle background message.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const ProviderScope(
    child: MaterialApp(
      home: MyApp(),
    ),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

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
                title: const Text('車窓Grapher'),
              ),
              body: const WebView(),
              floatingActionButton: const ToggleAlarmButton(),
            )));
  }
}
