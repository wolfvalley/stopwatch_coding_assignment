# Stopwatch App Coding Assignment

A simple stopwatch Android application built with the Flutter framework.

## Features

- Start, pause, resume, and reset functionality
- Centisecond-precision elapsed time display
- Digital and analog stopwatch display modes
- Switchable display mode without interrupting the running stopwatch
- Analog stopwatch with:
    - 60-second main dial
    - 60-minute subdial
    - Smooth hand movement based on elapsed time
- Lap recording with lap and split times
- Draggable lap history panel
- Clearable lap history
- Custom stopwatch-inspired Material UI
- Portrait-only orientation
- Separation of UI, presentation state, and stopwatch logic
- Unit and widget tests covering stopwatch behavior and user interactions


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
 |-- app          - place of MaterialApp and theme
 |-- controllers/ - stopwatch state and business logic
 |-- models/      - data models
 |-- screens/     - application screens
 |-- utils/       - utilities
 |-- widgets/     - reusable UI components
 `-- main.dart    - entry point of the application
```

## Testing

The project includes widget tests covering the main stopwatch functionality, including:

- Start, pause, resume, and reset
- Stopwatch state transitions
- Enabled and disabled button states
- Lap recording and lap time calculations
- Lap history clearing
- Digital display as the default mode
- Switching between digital and analog display modes
- Stopwatch controls in analog mode
- Lap recording in analog mode


The `StopwatchController` manages the stopwatch state, elapsed time, and lap data independently from the UI.

The digital and analog displays use the same elapsed time source, allowing the user to switch between display modes without affecting the running stopwatch.

## Testing

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

