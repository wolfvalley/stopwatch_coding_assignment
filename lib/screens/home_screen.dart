import 'package:flutter/material.dart';
import 'package:stopwatch_coding_assignment/controllers/stopwatch_controller.dart';
import 'package:stopwatch_coding_assignment/widgets/stopwatch_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StopwatchController _controller = StopwatchController();

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: StopwatchView(
              controller: _controller,
            ),
          ),
        ),
      ),
    );
  }
}