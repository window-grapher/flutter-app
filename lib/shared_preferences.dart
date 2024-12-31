import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtility {
  static const String isAlarmSoundOnKey = 'isAlarmSoundOn';
  static const String isVibrationOnKey = 'isVibrationOn';

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

  void setAlarmSoundEnabled({required bool isEnabled}) {
    sharedPreferences.setBool(isAlarmSoundOnKey, isEnabled);
  }

  void setVibrationEnabled({required bool isEnabled}) {
    sharedPreferences.setBool(isVibrationOnKey, isEnabled);
  }
}
