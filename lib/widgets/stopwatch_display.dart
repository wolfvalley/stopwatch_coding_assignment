import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stopwatch_coding_assignment/utils/duration_formatter.dart';

class StopwatchDisplay extends StatelessWidget {
  const StopwatchDisplay({
    required this.elapsed,
    super.key,
  });

  final ValueListenable<Duration> elapsed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white24,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: ValueListenableBuilder<Duration>(
          valueListenable: elapsed,
          builder: (context, value, _) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatDuration(value),
                key: const Key('elapsedTime'),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: Colors.black87,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}