import 'dart:async';
import 'dart:ui';

import 'package:alarm/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

const String portName = 'portName';
Timer timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {});

startAlarm() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.reload();
  final sharedPreferencesUtility =
      SharedPreferencesUtility(sharedPreferences: sharedPreferences);
  print("alarm sound ${sharedPreferencesUtility.isAlarmSoundEnabled()}, "
      "vibration ${sharedPreferencesUtility.isVibrationEnabled()}");
  if (sharedPreferencesUtility.isAlarmSoundEnabled()) {
    FlutterRingtonePlayer().playAlarm();
  }
  if (sharedPreferencesUtility.isVibrationEnabled()) {
    timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      Vibration.vibrate(duration: 1000);
    });
  }
}

void stopAlarm() async {
  await FlutterRingtonePlayer().stop();
  timer.cancel();
}

class StopAlarmButton extends ConsumerWidget {
  const StopAlarmButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () async {
        stopAlarm();
        IsolateNameServer.lookupPortByName(portName)?.send("stop");
      },
      icon: const Icon(Icons.alarm_off),
      label: const Text('Stop Alarm'),
    );
  }
}
