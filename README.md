# Stopwatch App Coding Assignment

A simple stopwatch Android application built with the Flutter framework.

## Features

- Start, pause, resume, and reset functionality
- Millisecond-precision elapsed time display
- Custom stopwatch-inspired Material UI
- Portrait-only orientation
- Separation of UI and stopwatch logic
- Widget tests covering the main interactions and edge cases

## Technologies

This project uses the following technologies:

- Flutter
- Dart
- Android
- Material Design

## Requirements

To run the project, you need:

- Flutter SDK
- Dart SDK
- Android SDK
- Android Studio or Visual Studio Code
- Android emulator or a physical Android device

You can check your Flutter installation by running:

```bash
flutter doctor
```
## Installation

Clone the repository

```bash
git clone <repository-url>
```

Navigate to the project directory

```bash
cd <project-folder>
```

Install the required dependencies:

```bash
flutter pub get
```

## Running the Application

Start an Android emulator or connect a physical Android device.

Check the available devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

## Project Structure

The main source code of the Flutter application is located in the `lib/` directory.

```text
lib/ 
 |--controllers/ - stopwatch state and business logic
 |-- widgets/    - reusable UI components
 |-- screens/    - application screens
 `-- main.dart   - entry point of the application
```

## Testing

The project includes widget tests covering the main stopwatch functionality, including:

- Start
- Pause
- Resume
- Reset
- Disabled button states
- Stopwatch state transitions

Run the tests with:

```bash
flutter test
```

## Android Build

Build a debug APK:

```bash
flutter build apk --debug
```
Build a release APK:
```bash
flutter build apk --release
```
The generated APK files can be found in:
```bash
build/app/outputs/flutter-apk
```

## Developer
Name: Kolos Farkasvölgyi

Github: https://github.com/wolfvalley/

