import 'dart:async';
import 'package:flutter/material.dart';

enum StopwatchStatus {
  initial,
  running,
  paused,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stopwatch _stopwatch = Stopwatch();

  final ValueNotifier<Duration> _elapsed = ValueNotifier(Duration.zero);

  Timer? _timer;
  StopwatchStatus _status = StopwatchStatus.initial;

  /// sets the stopwatch to running state
  void _run(){
    _stopwatch.start();
    _startTimer();

    setState(() {
      _status = StopwatchStatus.running;
    });
  }

  /// only starts the stopwatch, if it is set to zero
  void _start() {
    if (_status != StopwatchStatus.initial) return;

    _run();
  }

  /// pauses the stopwatch, when it is running
  void _pause() {
    if (_status != StopwatchStatus.running) return;

    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;

    setState(() {
      _status = StopwatchStatus.paused;
    });
  }

  /// resumes the stopwatch, when it is pause
  void _resume() {
    if (_status != StopwatchStatus.paused) return;

    _run();
  }

  /// resets the value of the stopwatch to zero
  void _reset() {
    _stopwatch
        ..stop()
        ..reset();

    _timer?.cancel();
    _timer = null;

    _elapsed.value = Duration.zero;

    setState(() {
      _status = StopwatchStatus.initial;
    });
  }

  /// starts the timer
  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 1),
          (_) {
            _elapsed.value = _stopwatch.elapsed;
          },
    );
  }

  /// conditions the functionality of PAUSE/RESUME button
  void _togglePause() {
    switch (_status) {
      case StopwatchStatus.initial:
        return;

      case StopwatchStatus.running:
        _pause();

      case StopwatchStatus.paused:
        _resume();
    }
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
  void dispose() {
    _timer?.cancel();
    _elapsed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<Duration>(
              valueListenable: _elapsed,
              builder: (context, elapsed, child) {
                return Text(
                  _formattedDuration(elapsed),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            ),

            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _status == StopwatchStatus.initial ? _start : null,
                  child: const Text('START'),
                ),

                ElevatedButton(
                  onPressed: _status == StopwatchStatus.initial ? null : _togglePause,
                  child: Text(
                    _status == StopwatchStatus.paused ? 'RESUME' : 'PAUSE',
                  ),
                ),

                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('RESET'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}