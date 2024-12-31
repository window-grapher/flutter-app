import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider.dart';

class AlarmSettingsDrawer extends ConsumerWidget {
  const AlarmSettingsDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Text('設定')),
          ListTile(
            title: const Text('アラーム音'),
            trailing: Switch(
              value: ref.watch(sharedUtilityProvider).isAlarmSoundEnabled(),
              onChanged: (value) {
                ref
                    .watch(sharedUtilityProvider)
                    .setAlarmSoundEnabled(isEnabled: value);
                ref.invalidate(sharedUtilityProvider);
              },
            ),
          ),
          ListTile(
            title: const Text('バイブレーション'),
            trailing: Switch(
              value: ref.watch(sharedUtilityProvider).isVibrationEnabled(),
              onChanged: (value) {
                ref
                    .watch(sharedUtilityProvider)
                    .setVibrationEnabled(isEnabled: value);
                ref.invalidate(sharedUtilityProvider);
              },
            ),
          ),
        ],
      ),
    );
  }
}
