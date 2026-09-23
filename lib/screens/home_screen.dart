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

  Timer? _timer;
  StopwatchStatus _status = StopwatchStatus.initial;

  /// only starts the stopwatch it is set to zero
  void _start() {
    if (_status == StopwatchStatus.running) return;

    _stopwatch.start();
    _status = StopwatchStatus.running;

    _startTimer();

  }

  /// pause the stopwatch, when it is running
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

    _start();
  }

  /// reset the value of the stopwatch to zero
  void _reset() {
    _stopwatch
        ..stop()
        ..reset();

    _timer?.cancel();
    _timer = null;

    setState(() {
      _status = StopwatchStatus.initial;
    });
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
          (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  /// conditioning the functionality of PUASE/RESUME button
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

  /// formatting the ellapsed time to min:sec:ms format
  String get _formattedElapsed {
    final elapsed = _stopwatch.elapsed;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formattedElapsed,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
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