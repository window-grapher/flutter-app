import 'package:alarm/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/main_webview.dart';

final webViewNotifierProvider =
    NotifierProvider<WebViewNotifier, WebViewState>(WebViewNotifier.new);
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});
final sharedUtilityProvider = Provider<SharedPreferencesUtility>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SharedPreferencesUtility(sharedPreferences: sharedPrefs);
});
