import 'package:flutter/material.dart';
import '../controllers/stopwatch_controller.dart';
import '../widgets/laps_display.dart';
import '../widgets/stopwatch_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final StopwatchController _controller;

  @override
  void initState() {
    super.initState();

    _controller = StopwatchController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 16,
                  right: 16,
                ),
                child: StopwatchView(
                  controller: _controller,
                ),
              ),
            ),

            LapDisplay(
              controller: _controller,
            ),
          ],
        ),
      ),
    );
  }
}