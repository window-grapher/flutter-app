import 'dart:async';

import 'package:alarm/firebase.dart';
import 'package:alarm/permission.dart';
import 'package:alarm/provider.dart';
import 'package:alarm/ui/alarm_settings_drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/main_webview.dart';
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

  // Handle foreground message.
  handleMessage((title, message) => {LocalNotification().show(title, message)});
  // Handle background message.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: MaterialApp(
      home: MyApp(fcmToken ?? ""),
    ),
  ));
}

class MyApp extends ConsumerWidget {
  final String fcmToken;

  const MyApp(this.fcmToken, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        home: PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              ref.watch(webViewNotifierProvider).webViewController?.goBack();
            },
            child: Scaffold(
              drawer: const AlarmSettingsDrawer(),
              appBar: AppBar(
                title: const Text('ぽいくる'),
              ),
              body: WebView(fcmToken),
              // floatingActionButton: const StopAlarmButton(),
            )));
  }
}
