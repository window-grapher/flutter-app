import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceIdManager {
  static const _deviceIdKey = "device_id";

  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);
    if (deviceId == null) {
      // Generate a new device ID
      deviceId = _generateDeviceId();
      await prefs.setString(_deviceIdKey, deviceId);
    }
    return deviceId;
  }

  static String _generateDeviceId() {
    const length = 16;
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    final random = Random();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }
}
