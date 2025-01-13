import 'package:alarm/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebView extends ConsumerWidget {
  final String fcmToken;
  final String deviceId;
  final String urlBase;

  const WebView(this.fcmToken, this.deviceId, this.urlBase, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = "$urlBase?fcm=$fcmToken&device_id=$deviceId";
    return InAppWebView(
      gestureRecognizers: {
        Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer()
        )
      },
      onGeolocationPermissionsShowPrompt:
          (InAppWebViewController controller, String origin) async {
        return GeolocationPermissionShowPromptResponse(
          origin: origin,
          allow: true,
          retain: true,
        );
      },
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: InAppWebViewSettings(
          javaScriptCanOpenWindowsAutomatically: true,
          geolocationEnabled: true,
          javaScriptEnabled: true),
      onWebViewCreated: (controller) => {
        ref.read(webViewNotifierProvider.notifier).setController(controller)
      },
    );
  }
}

class WebViewState {
  InAppWebViewController? webViewController;
}

class WebViewNotifier extends Notifier<WebViewState> {
  @override
  WebViewState build() {
    return WebViewState();
  }

  void setController(InAppWebViewController controller) {
    state.webViewController = controller;
  }
}
