import 'dart:async';
import 'package:flutter/foundation.dart';

enum StopwatchStatus {
  initial,
  running,
  paused,
}

class StopwatchController extends ChangeNotifier {
  final Stopwatch _stopwatch = Stopwatch();

  final ValueNotifier<Duration> elapsed =
  ValueNotifier(Duration.zero);

  Timer? _timer;
  StopwatchStatus _status = StopwatchStatus.initial;

  StopwatchStatus get status => _status;

  bool get isInitial => _status == StopwatchStatus.initial;
  bool get isRunning => _status == StopwatchStatus.running;
  bool get isPaused => _status == StopwatchStatus.paused;

  /// only starts the stopwatch, if it is set to zero
  void start() {
    if (_status != StopwatchStatus.initial) return;

    _run();
  }

  /// pauses the stopwatch, when it is running
  void pause() {
    if (_status != StopwatchStatus.running) return;

    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;

    _status = StopwatchStatus.paused;

    notifyListeners();
  }

  /// resumes the stopwatch, when it is paused
  void resume() {
    if (_status != StopwatchStatus.paused) return;

    _run();
  }

  /// resets the value of the stopwatch to zero
  void reset() {
    _stopwatch
      ..stop()
      ..reset();

    _timer?.cancel();
    _timer = null;

    elapsed.value = Duration.zero;
    _status = StopwatchStatus.initial;

    notifyListeners();
  }

  /// conditions the functionality of PAUSE/RESUME button
  void togglePause() {
    switch (_status) {
      case StopwatchStatus.initial:
        return;

      case StopwatchStatus.running:
        pause();

      case StopwatchStatus.paused:
        resume();
    }
  }

  /// starts the stopwatch and the timer
  void _run() {
    _stopwatch.start();
    _status = StopwatchStatus.running;

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 1),
          (_) {
        elapsed.value = _stopwatch.elapsed;
      },
    );

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    elapsed.dispose();
    super.dispose();
  }
}