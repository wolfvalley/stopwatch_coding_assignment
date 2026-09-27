import 'package:flutter/material.dart';
import 'package:stopwatch_coding_assignment/widgets/stopwatch_controls.dart';
import 'package:stopwatch_coding_assignment/widgets/stopwatch_display.dart';
import '../controllers/stopwatch_controller.dart';


class StopwatchView extends StatelessWidget {
  const StopwatchView({
    required this.controller,
    super.key,
  });

  final StopwatchController controller;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              top: 25,
              child: _StopwatchBody(
                controller: controller,
              ),
            ),

            Positioned(
              top: 0,
              left: 25,
              right: 25,
              child: StopwatchControls(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StopwatchBody extends StatelessWidget {
  const _StopwatchBody({
    required this.controller,
  });

  final StopwatchController controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [
              Colors.black12,
              Colors.black87,
            ],
          ),

          border: Border.all(
            color: Colors.white24,
            width: 6,
          ),

          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 25,
              spreadRadius: 2,
              offset: Offset(0, 12),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white12,
            border: Border.all(
              color: Colors.black38,
              width: 5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                _LapButton(
                  controller: controller,
                ),

                StopwatchDisplay(
                  elapsed: controller.elapsed,
                ),

                const SizedBox(height: 25),

                const Text(
                  'STOPWATCH',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: 5),

                Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LapButton extends StatelessWidget {
  const _LapButton({
    required this.controller,
  });

  final StopwatchController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: 65,
            height: 45,
            child: ElevatedButton(
              key: const Key('lapButton'),
              onPressed: controller.isRunning
                  ? controller.addLap
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
                disabledBackgroundColor: Colors.white12,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'LAP',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}