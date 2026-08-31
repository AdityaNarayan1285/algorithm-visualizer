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
            .generateArray(20);
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
          // Array values
          // --------------------------------------------------

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Array',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 8),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      state.array.length,
                      (index) {
                        final isActive =
                            index == state.activeIndexA ||
                                index == state.activeIndexB;

                        return Column(
                          children: [
                            // Index
                            SizedBox(
                              width: 48,
                              child: Text(
                                '$index',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Value cell
                            Container(
                              width: 48,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.red
                                    : Theme.of(context)
                                        .colorScheme
                                        .surface,
                                border: Border.all(
                                  color: isActive
                                      ? Colors.red
                                      : Theme.of(context)
                                          .colorScheme
                                          .outline,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                '${state.array[index]}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isActive
                                      ? Colors.white
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
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
                        controller.generateArray(20);
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