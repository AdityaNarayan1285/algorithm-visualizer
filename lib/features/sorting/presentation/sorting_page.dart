import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/sort_state.dart';
import 'sort_providers.dart';
import 'widgets/sort_bars_painter.dart';

class SortingPage extends ConsumerWidget {
  const SortingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sortControllerProvider);

    // Generate the initial array when the page opens.
    if (state.array.isEmpty) {
      Future.microtask(() {
        ref
            .read(sortControllerProvider.notifier)
            .generateArray(30);
      });
    }

    final controller =
        ref.read(sortControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.algorithmName),
      ),

      body: Column(
        children: [
          // --------------------------------------------------
          // Sorting bars
          // --------------------------------------------------

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CustomPaint(
                painter: SortBarsPainter(
                  array: state.array,
                  activeIndexA: state.activeIndexA,
                  activeIndexB: state.activeIndexB,
                  maxValue: 100,
                ),
                size: Size.infinite,
              ),
            ),
          ),

          // --------------------------------------------------
          // Control panel
          // --------------------------------------------------

          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Playback controls
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.skip_previous,
                        ),
                        tooltip: 'Step backward',
                        onPressed: controller.stepBackward,
                      ),

                      IconButton(
                        icon: Icon(
                          state.status == SortStatus.running
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        tooltip:
                            state.status == SortStatus.running
                                ? 'Pause'
                                : 'Play',
                        onPressed: state.status ==
                                SortStatus.running
                            ? controller.pause
                            : controller.play,
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.skip_next,
                        ),
                        tooltip: 'Step forward',
                        onPressed: controller.stepForward,
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.restart_alt,
                        ),
                        tooltip: 'Reset',
                        onPressed: controller.reset,
                      ),
                    ],
                  ),

                  // --------------------------------------------------
                  // Speed
                  // --------------------------------------------------

                  Row(
                    children: [
                      const Icon(Icons.speed),

                      Expanded(
                        child: Slider(
                          min: 10,
                          max: 500,
                          value: state.speed.clamp(10, 500),
                          onChanged: controller.setSpeed,
                        ),
                      ),
                    ],
                  ),

                  // --------------------------------------------------
                  // New array
                  // --------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.generateArray(30);
                      },
                      child: const Text('New Array'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
