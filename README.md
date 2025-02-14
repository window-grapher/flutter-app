# Poicle (Alarm App)

Currently, **only Android** is supported in this project. The following instructions focus solely on building and running the app on Android devices and emulators.

## Table of Contents

- [Features](#features)
- [App Overview](#app-overview)
- [Requirements](#requirements)
- [Getting Started](#getting-started)
  - [1. Clone the Repository](#1-clone-the-repository)
  - [2. Install Flutter & Dart](#2-install-flutter--dart)
  - [3. Install Dependencies](#3-install-dependencies)
- [Running on Android](#running-on-android)
- [Firebase Configuration (Android)](#firebase-configuration-android)
- [Building for Release (Android)](#building-for-release-android)
- [Docker Workflow (Android)](#docker-workflow-android)
- [Testing](#testing)
- [License](#license)

---

## Features

- **Alarm Scheduling**
  The app triggers vibrations or alarm sounds based on Firebase Cloud Messaging (FCM) notifications.
- **Firebase Messaging Integration**
  Sends the device's FCM token to the web app to receive push notifications.
- **WebView with FCM Token Communication**
  Embeds a WebView and passes the FCM token to the web application for notifications.
- **Minimal Native Functionality**
  Acts as a bridge between the web app and the native functionalities (vibration or alarm sound).
- **Permissions Handling**
  Requests necessary permissions, including vibration and exact alarm scheduling.

---

## App Overview

Poicle is a **companion app for a web-based notification system**. It primarily serves as a bridge between a web app and a user's mobile device by performing the following:

1. **WebView with FCM Token Injection**
   - The app loads a WebView containing a web application.
   - It passes the Firebase Cloud Messaging (FCM) token to the web app, allowing the server to send push notifications to the device.

2. **Receiving Push Notifications**
   - The app listens for notifications from Firebase Cloud Messaging.
   - When a notification is received, it triggers either a **vibration** or an **alarm sound** on the device.

3. **No Other Native Features**
   - The app does not store messages or process notifications beyond triggering a vibration or alarm.
   - It relies entirely on the web application to manage and dispatch notifications.

This setup enables the web application to fully control when a user’s device vibrates or plays an alarm sound.

---

## Requirements

1. **Flutter SDK** (>= 3.3.4 < 4.0.0)
2. **Dart SDK** (bundled with Flutter)
3. **Android Studio** (or a comparable IDE) for running and debugging
4. **Firebase Account** (if you plan to use push notifications)
5. **Docker** (optional, if you want to build the Android release within a container)

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/window-grapher/flutter-app.git
cd flutter-app
```

### 2. Install Flutter & Dart

Ensure you have Flutter installed and in your system’s PATH:

```bash
flutter --version
```

### 3. Install Dependencies

From the project root, run:

```bash
flutter pub get
```

---

## Running on Android

To run on an Android emulator or physical device:

1. Start an Android emulator or connect an Android device.
2. Run the following command in the project root:
   ```bash
   flutter run
   ```
3. The app will launch on your selected device/emulator.

---

## Firebase Configuration (Android)

1. Place your `google-services.json` file inside `android/app/`.
2. Update the `applicationId` in `android/app/build.gradle` if it differs from your Firebase project’s package name.
3. Make sure to include the Gradle plugin for Google Services in `android/build.gradle` or `android/app/build.gradle` if not already present.

---

## Building for Release (Android)

To generate a release bundle (`.aab`) for the Play Store:

```bash
flutter build appbundle --release
```

The output file is typically found at `build/app/outputs/bundle/release/app-release.aab`.

If you need an APK:

```bash
flutter build apk --release
```

---

## Docker Workflow (Android)

### Using Docker Compose

This repository includes a `docker-compose.yml` that demonstrates building the Android release bundle inside a container:

1. **Build the Docker image** (optional, if you want to update):
   ```bash
   docker-compose build
   ```
2. **Run the Flutter build**:
   ```bash
   docker-compose run flutter-builder
   ```
   By default, this command runs:
   ```bash
   flutter build appbundle --release
   ```
   and outputs the AAB file to your local machine in `build/app/outputs/bundle/release/`.

Feel free to modify the `command` in `docker-compose.yml` if you want to build an APK or pass other arguments.

---

## Testing

A sample test is located in `test/widget_test.dart`. To run tests:

```bash
flutter test
```

You can add additional tests in the `test` directory as your project grows.

---

## License

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.

```
Copyright 2024

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

For more details, visit [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).
