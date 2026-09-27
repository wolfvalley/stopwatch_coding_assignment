import 'package:flutter/material.dart';
import '../controllers/stopwatch_controller.dart';
import 'lap_item.dart';

class LapDisplay extends StatelessWidget {
  const LapDisplay({
    required this.controller,
    super.key,
  });

  final StopwatchController controller;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.18,
      minChildSize: 0.18,
      maxChildSize: 0.4,
      snap: true,
      snapSizes: const [ 0.18,0.4],
      builder: (context, scrollController) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 15,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                final laps = controller.laps;

                return CustomScrollView(
                  key: const Key('lapScrollView'),
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: _LapHeader(
                        hasLaps: laps.isNotEmpty,
                        onClear: controller.clearLaps,
                      ),
                    ),

                    if (laps.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyLapState(),
                      )
                    else
                      SliverList.builder(
                        itemCount: laps.length,
                        itemBuilder: (context, index) {
                          return LapItem(
                            lap: laps[index],
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _LapHeader extends StatelessWidget {
  const _LapHeader({
    required this.hasLaps,
    required this.onClear,
  });

  final bool hasLaps;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),

        Container(
          width: 42,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20,4,12,0),
          child: Row(
            children: [
              const Text(
                'LAPS',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              TextButton(
                key: const Key('clearLapsButton'),
                onPressed: hasLaps
                    ? onClear
                    : null,
                child: Text(
                  'CLEAR',
                  style: TextStyle(
                    fontSize: 11,
                    color: hasLaps ? Colors.deepOrange : Colors.white24,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  '#',
                  style: _headerStyle,
                ),
              ),
              Expanded(
                child: Text(
                  'LAP',
                  textAlign: TextAlign.center,
                  style: _headerStyle,
                ),
              ),
              Expanded(
                child: Text(
                  'SPLIT',
                  textAlign: TextAlign.center,
                  style: _headerStyle,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8),

        Divider(
          height: 1,
          color: Colors.white12,
        ),
      ],
    );
  }

  static const _headerStyle = TextStyle(
    color: Colors.white54,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );
}

class _EmptyLapState extends StatelessWidget {
  const _EmptyLapState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Text(
          'No laps recorded',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}