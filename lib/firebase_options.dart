// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAoQhlI5zyyUllojQp4X4vXapdJl8Vm6Ao',
    appId: '1:329621320065:web:611fc8e45cbdda1dc1b880',
    messagingSenderId: '329621320065',
    projectId: 'window-grapher',
    authDomain: 'window-grapher.firebaseapp.com',
    storageBucket: 'window-grapher.firebasestorage.app',
    measurementId: 'G-P31CCZ6RZT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBi2Ke4NGqor5OZLocozQr49X4Bf3PBJvY',
    appId: '1:329621320065:android:a2ae282ef040d245c1b880',
    messagingSenderId: '329621320065',
    projectId: 'window-grapher',
    storageBucket: 'window-grapher.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLsBNgq41G8em2kp_l6BMxJ8rr65nkW60',
    appId: '1:329621320065:ios:8d9d4c15b015eb13c1b880',
    messagingSenderId: '329621320065',
    projectId: 'window-grapher',
    storageBucket: 'window-grapher.firebasestorage.app',
    iosBundleId: 'poicle.com.alarm',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDLsBNgq41G8em2kp_l6BMxJ8rr65nkW60',
    appId: '1:329621320065:ios:8d9d4c15b015eb13c1b880',
    messagingSenderId: '329621320065',
    projectId: 'window-grapher',
    storageBucket: 'window-grapher.firebasestorage.app',
    iosBundleId: 'poicle.com.alarm',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAoQhlI5zyyUllojQp4X4vXapdJl8Vm6Ao',
    appId: '1:329621320065:web:3076cdbd728c0071c1b880',
    messagingSenderId: '329621320065',
    projectId: 'window-grapher',
    authDomain: 'window-grapher.firebaseapp.com',
    storageBucket: 'window-grapher.firebasestorage.app',
    measurementId: 'G-DMQMBB79KL',
  );
}
