import 'package:alarm/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebView extends ConsumerWidget {
  const WebView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InAppWebView(
      onGeolocationPermissionsShowPrompt:
          (InAppWebViewController controller, String origin) async {
        return GeolocationPermissionShowPromptResponse(
          origin: origin,
          allow: true,
          retain: true,
        );
      },
      initialUrlRequest:
          URLRequest(url: WebUri("https://window-grapher.app.takoyaki3.com")),
      initialSettings: InAppWebViewSettings(
        javaScriptCanOpenWindowsAutomatically: true,
        geolocationEnabled: true,
        javaScriptEnabled: true,
      ),
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
