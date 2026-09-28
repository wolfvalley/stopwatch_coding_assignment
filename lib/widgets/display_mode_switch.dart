import 'package:flutter/material.dart';
import 'package:stopwatch_coding_assignment/widgets/stopwatch_view.dart';


class DisplayModeSwitch extends StatelessWidget {
  const DisplayModeSwitch({
    required this.mode,
    required this.onChanged,
    super.key,
  });

  final StopwatchDisplayMode mode;
  final ValueChanged<StopwatchDisplayMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<StopwatchDisplayMode>(
      segments: const [
        ButtonSegment(
          value: StopwatchDisplayMode.digital,
          label: Text('DIGITAL'),
          icon: Icon(Icons.watch_outlined),
        ),
        ButtonSegment(
          value: StopwatchDisplayMode.analog,
          label: Text('ANALOG'),
          icon: Icon(Icons.timer_outlined),
        ),
      ],
      selected: {mode},
      showSelectedIcon: false,
      onSelectionChanged: (selection) {
        onChanged(selection.first);
      },
    );
  }
}