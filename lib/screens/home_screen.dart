import 'package:flutter/material.dart';
import 'package:stopwatch_coding_assignment/controllers/stopwatch_controller.dart';

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

  /// formats the elapsed time to mm:ss.SSS (00:00.000) format
  String _formattedDuration(Duration elapsed) {

    final minutes = elapsed.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds = elapsed.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final milliseconds = (elapsed.inMilliseconds % 1000 )
        .toString()
        .padLeft(3, '0');

    return '$minutes:$seconds.$milliseconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<Duration>(
              valueListenable: _controller.elapsed,
              builder: (context, elapsed, child) {
                return Text(
                  _formattedDuration(elapsed),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 50,),
            ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed:
                      _controller.isInitial
                          ? _controller.start
                          : null,
                      child: const Text('START'),
                    ),

                    ElevatedButton(
                      onPressed:
                      _controller.isInitial
                          ? null
                          : _controller.togglePause,
                      child: Text(
                        _controller.isPaused
                            ? 'RESUME'
                            : 'PAUSE',
                      ),
                    ),

                    ElevatedButton(
                      onPressed: _controller.reset,
                      child: const Text('RESET'),
                    ),
                  ],
                );
              },
            )
          ],
        )
      ),
    );
  }
}