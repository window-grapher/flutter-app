import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermission() async {
  // Location
  const locationPermission = Permission.location;
  if (await locationPermission.isDenied) {
    await locationPermission.request();
  }

  // Notification
  const notificationPermission = Permission.notification;
  if (await notificationPermission.isDenied) {
    await notificationPermission.request();
  }

  // Sound
  const soundPermission = Permission.audio;
  if (await soundPermission.isDenied) {
    await soundPermission.request();
  }
}