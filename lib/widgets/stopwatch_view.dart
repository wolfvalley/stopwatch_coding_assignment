import 'package:flutter/material.dart';
import 'package:stopwatch_coding_assignment/widgets/stopwatch_controls.dart';
import 'package:stopwatch_coding_assignment/widgets/stopwatch_display.dart';
import '../controllers/stopwatch_controller.dart';
import 'package:stopwatch_coding_assignment/widgets/analog_stopwatch_display.dart';
import 'package:stopwatch_coding_assignment/widgets/display_mode_switch.dart';

enum StopwatchDisplayMode {
  digital,
  analog,
}

class StopwatchView extends StatefulWidget {
  const StopwatchView({
    required this.controller,
    super.key,
  });

  final StopwatchController controller;

  @override
  State<StopwatchView> createState() =>
      _StopwatchViewState();
}

class _StopwatchViewState extends State<StopwatchView> {
  StopwatchDisplayMode _displayMode =
      StopwatchDisplayMode.digital;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DisplayModeSwitch(
            mode: _displayMode,
            onChanged: (mode) {
              setState(() {
                _displayMode = mode;
              });
            },
          ),

          const SizedBox(height: 12),

          AspectRatio(
            aspectRatio: 0.8,
            child: _displayMode == StopwatchDisplayMode.digital
                ? _DigitalStopwatchLayout(
              controller: widget.controller,
            )
                : _AnalogStopwatchLayout(
              controller: widget.controller,
            ),
          ),
        ],
      ),
    );
  }}

class _AnalogStopwatchLayout extends StatelessWidget {
  const _AnalogStopwatchLayout({
    required this.controller,
  });

  final StopwatchController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: StopwatchControls(
            controller: controller,
          ),
        ),

        const SizedBox(height: 8),

        LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth * 0.8;

            return SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnalogStopwatchDisplay(
                    elapsed: controller.elapsed,
                  ),

                  Positioned(
                    bottom: 50,
                    child: _LapButton(
                      controller: controller,
                      letterColor: Colors.amber,
                      backgroundColor: Colors.transparent,
                      borderColor: Colors.amber,
                      disabledColor: Colors.red.shade50,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DigitalStopwatchLayout extends StatelessWidget {
  const _DigitalStopwatchLayout({
    required this.controller,
  });

  final StopwatchController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          top: 25,
          child: AspectRatio(
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
    );
  }
}

class _LapButton extends StatelessWidget {
  const _LapButton({
    required this.controller,
    this.letterColor = Colors.white,
    this.backgroundColor = Colors.amber,
    this.borderColor = Colors.transparent,
    this.disabledColor = Colors.white10,
  });

  final StopwatchController controller;
  final Color letterColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color disabledColor;

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
            child: OutlinedButton(
              key: const Key('lapButton'),
              onPressed: controller.isRunning ? controller.addLap : null,
              style: OutlinedButton.styleFrom(
                backgroundColor: backgroundColor,
                disabledBackgroundColor: disabledColor,
                foregroundColor: letterColor,
                padding: EdgeInsets.zero,
                side: BorderSide(
                  color: borderColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('LAP',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: letterColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}