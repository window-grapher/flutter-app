import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermission() async {
  const permission = Permission.location;

  if (await permission.isDenied) {
    await permission.request();
  }
}