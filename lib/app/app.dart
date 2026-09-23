import 'package:flutter/material.dart';
import 'package:stopwatch_coding_assignment/app/theme.dart';

import '../screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Stopwatch',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: HomeScreen(),
      );
  }
}