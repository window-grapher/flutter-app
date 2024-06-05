import 'package:alarm/permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermission();
  runApp(
    const MaterialApp(
      home: WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
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
            )
        )
    );
  }
}
