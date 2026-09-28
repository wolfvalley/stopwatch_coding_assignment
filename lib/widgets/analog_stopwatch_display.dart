import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stopwatch_coding_assignment/utils/dial_utils.dart';

/// Displays the stopwatch elapsed time using an analog representation.
class AnalogStopwatchDisplay extends StatelessWidget {
  const AnalogStopwatchDisplay({
    required this.elapsed,
    super.key,
  });

  final ValueListenable<Duration> elapsed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: elapsed,
      builder: (_, value, __) {
        return AspectRatio(
          aspectRatio: 1,
          child: Stack(
            key: const Key('analogStopwatchDisplay'),
            alignment: Alignment.center,
            children: [

              /// Small dial: represents minutes
              Align(
                alignment: const Alignment(0, -0.42),
                child: FractionallySizedBox(
                  widthFactor: 0.30,
                  heightFactor: 0.30,
                  child: _Dial(
                    value:
                    value.inMilliseconds /
                        Duration.millisecondsPerMinute,
                    handColor: Colors.black87,
                    fontSize: 8,
                  ),
                ),
              ),
              /// Main dial: represents seconds.
              _Dial(
                value: value.inMilliseconds / 1000,
                handColor: Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Reuseable 0-60 dial
class _Dial extends StatelessWidget {
  const _Dial({
    required this.value,
    required this.handColor,
    this.fontSize = 14,
  });

  /// Current value displayed by the hand.
  final double value;
  final Color handColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    /// Convert the current value from the 0–60 scale into radians.
    final angle = dialValueToRadians(value);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(255, 250, 240, 0.2),
        border: Border.all(
          color: Colors.black87,
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Labels for time from 00 to 55
          for (var value = 0; value < 60; value += 5)
            _DialLabel(
              value: value,
              fontSize: fontSize,
            ),

          LayoutBuilder(
            builder: (context, constraints) {
              final handLength = constraints.maxHeight * 0.48;

              /// Rotate the hand around the center of the dial.
              return Transform.rotate(
                angle: angle,
                child: Center(
                  child: Transform.translate(
                    offset: Offset(0,-handLength / 2),
                    child: Container(
                      width: 2,
                      height: handLength,
                      decoration: BoxDecoration(
                        color: handColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          /// Center point of the watch
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: handColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dial label
class _DialLabel extends StatelessWidget {
  const _DialLabel({
    required this.value,
    required this.fontSize,
  });

  final int value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    /// calculate label position
    final angle = dialValueToRadians(value);

    return Align(
      alignment: Alignment(
        math.sin(angle) * 0.95,
        -math.cos(angle) * 0.95,
      ),
      child: Text(
        value.toString().padLeft(2, '0'),
        style: TextStyle(
          color: Colors.black87,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}