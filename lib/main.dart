import 'dart:async';

import 'package:alarm/firebase.dart';
import 'package:alarm/permission.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
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
  handleMessage((message) => {
    LocalNotification().show("foreground", message)
  });
  // Handle background message.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(
    const MaterialApp(
      home: WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  var isRinging = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InAppWebViewController? webViewController;
    return MaterialApp(
        home: PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              webViewController?.goBack();
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('車窓Grapher'),
              ),
              body: InAppWebView(
                onGeolocationPermissionsShowPrompt:
                    (InAppWebViewController controller, String origin) async {
                  return GeolocationPermissionShowPromptResponse(
                    origin: origin,
                    allow: true,
                    retain: true,
                  );
                },
                initialUrlRequest: URLRequest(
                    url: WebUri("https://window-grapher.app.takoyaki3.com")),
                initialSettings: InAppWebViewSettings(
                  javaScriptCanOpenWindowsAutomatically: true,
                  geolocationEnabled: true,
                  javaScriptEnabled: true,
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: toggleAlarm,
                child: (!isRinging == true)
                    ? const Icon(Icons.alarm)
                    : const Icon(Icons.alarm_off),
              ),
            )));
  }

  void toggleAlarm() {
    setState(() {
      if (!isRinging) {
        Future.delayed(const Duration(seconds: 5), ()
        {
          LocalNotification().show("alarm", "alarm triggered");
          FlutterRingtonePlayer().playAlarm();
          timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
            Vibration.vibrate(duration: 1000);
          });
        });
      } else {
        timer?.cancel();
        FlutterRingtonePlayer().stop();
      }
      isRinging = !isRinging;
    });
  }
}
