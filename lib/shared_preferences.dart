import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtility {
  static const String isAlarmSoundOnKey = 'isAlarmSoundOn';
  static const String isVibrationOnKey = 'isVibrationOn';
  static const String currentTabIndexKey = 'tabIndex';

  SharedPreferencesUtility({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  bool isAlarmSoundEnabled() {
    return sharedPreferences.getBool(isAlarmSoundOnKey) ?? false;
  }

  bool isVibrationEnabled() {
    return sharedPreferences.getBool(isVibrationOnKey) ?? false;
  }

  int getCurrentTabIndex() {
    return sharedPreferences.getInt(currentTabIndexKey) ?? 0;
  }

  void setAlarmSoundEnabled({required bool isEnabled}) {
    sharedPreferences.setBool(isAlarmSoundOnKey, isEnabled);
  }

  void setVibrationEnabled({required bool isEnabled}) {
    sharedPreferences.setBool(isVibrationOnKey, isEnabled);
  }

  void setCurrentTabIndex({required int index}) {
    sharedPreferences.setInt(currentTabIndexKey, index);
  }
}
