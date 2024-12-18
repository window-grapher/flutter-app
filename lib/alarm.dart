import 'dart:async';

import 'package:alarm/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

import 'notification.dart';

class ToggleAlarmButton extends ConsumerWidget {
  const ToggleAlarmButton({
    super.key,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmState = ref.watch(alarmNotifierProvider);
    final alarmNotifier = ref.read(alarmNotifierProvider.notifier);

    return FloatingActionButton(
      onPressed: () {
        if (!alarmState.isRinging) {
         Future.delayed(const Duration(seconds: 5), () {
            LocalNotification().show("alarm", "alarm triggered");
            FlutterRingtonePlayer().playAlarm();
            alarmNotifier.setTimer(
                    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
                  Vibration.vibrate(duration: 1000);
                }));
          });
        } else {
          alarmNotifier.stopTimer();
          LocalNotification().show("alarm", "alarm stopped");
          FlutterRingtonePlayer().stop();
        }
        alarmNotifier.toggle();
      },
      child: alarmState.isRinging
          ? const Icon(Icons.alarm_off)
          : const Icon(Icons.alarm_on),
    );
  }
}

class AlarmState {
  bool isRinging = false;
  Timer? timer;
  AlarmState(this.isRinging, this.timer);
}

class AlarmNotifier extends Notifier<AlarmState> {
  @override
  AlarmState build() {
    return AlarmState(false, null);
  }

  void toggle() {
    state = AlarmState(!state.isRinging, state.timer);
  }

  void setTimer(Timer timer) {
    state.timer = timer;
  }

  void stopTimer() {
    state.timer?.cancel();
  }
}
