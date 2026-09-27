import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stopwatch_coding_assignment/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const App());
}
