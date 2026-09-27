import 'package:flutter/material.dart';
import '../controllers/stopwatch_controller.dart';

class StopwatchControls extends StatelessWidget {
  const StopwatchControls({
    required this.controller,
    super.key,
  });

  final StopwatchController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Transform.rotate(
              angle: -0.55,
              child: _StopwatchButton(
                buttonKey: const Key('resetButton'),
                onPressed: controller.reset,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: _StopwatchButton(
                buttonKey: const Key('pauseResumeButton'),
                onPressed: controller.isInitial
                    ? null
                    : controller.togglePause,
              ),
            ),
            Transform.rotate(
              angle: 0.55,
              child: _StopwatchButton(
                buttonKey: const Key('startButton'),
                onPressed: controller.isInitial
                    ? controller.start
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StopwatchButton extends StatelessWidget {
  const _StopwatchButton({
    required this.onPressed,
    required this.buttonKey,
  });

  final VoidCallback? onPressed;
  final Key buttonKey;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: Ink(
        width: 75,
        height: 45,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: enabled
                ? const [
              Colors.black54,
              Colors.black,
            ]
                : const [
              Colors.grey,
              Colors.black26,
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled
                ? Colors.white12
                : Colors.white10,
          ),
        ),
        child: InkWell(
          key: buttonKey,
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}