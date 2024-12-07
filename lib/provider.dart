import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'MainWebView.dart';
import 'alarm.dart';

final alarmNotifierProvider =
    NotifierProvider<AlarmNotifier, AlarmState>(AlarmNotifier.new);
final webViewNotifierProvider =
    NotifierProvider<WebViewNotifier, WebViewState>(WebViewNotifier.new);
