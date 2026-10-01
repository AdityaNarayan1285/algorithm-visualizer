import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/algorithm_status_banner.dart';
import '../domain/sort_event.dart';
import '../domain/sort_state.dart';
import 'sort_providers.dart';
import 'widgets/merge_sort_tree_widget.dart';
import 'widgets/sort_bars_painter.dart';

class SortingPage extends ConsumerWidget {
  const SortingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sortControllerProvider);

    final isMergeSort = state.algorithmName == 'Merge Sort';

    // Generate the initial array when the page opens.
    if (state.array.isEmpty) {
      Future.microtask(() {
        ref
            .read(sortControllerProvider.notifier)
            .generateArray(isMergeSort ? 8 : 20);
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
          // Status Text Banner (Displayed for all algorithms)
          // --------------------------------------------------
          AlgorithmStatusBanner(state: state),

          // --------------------------------------------------
          // Visualization (Tree Flowchart for Merge Sort, Bars for others)
          // --------------------------------------------------

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: isMergeSort
                  ? MergeSortTreeWidget(state: state)
                  : CustomPaint(
                      painter: SortBarsPainter(
                        array: state.array,
                        activeIndexA: state.activeIndexA,
                        activeIndexB: state.activeIndexB,
                        sortedIndices: state.sortedIndices,
                        maxValue: 100,
                        currentEventType: state.currentEventType,
                        algorithmName: state.algorithmName,
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

                        final isSorted =
                            state.sortedIndices.contains(index);

                        Color? cellColor;
                        if (state.currentEventType == SortEventType.split &&
                            state.activeIndexA != -1 &&
                            state.activeIndexB != -1 &&
                            index >= state.activeIndexA &&
                            index <= state.activeIndexB) {
                          final mid = state.activeIndexA +
                              (state.activeIndexB - state.activeIndexA) ~/ 2;
                          cellColor = index <= mid
                              ? Colors.purpleAccent
                              : Colors.cyan;
                        } else if (state.currentEventType == SortEventType.merge &&
                            index == state.activeIndexA) {
                          cellColor = Colors.orangeAccent;
                        } else if (state.currentEventType == SortEventType.pivot &&
                            index == state.activeIndexA) {
                          cellColor = Colors.deepPurpleAccent;
                        } else if (isActive) {
                          if (state.currentEventType == SortEventType.insert &&
                                  index == state.activeIndexA) {
                            cellColor = Colors.amber;
                          } else if (state.algorithmName == 'Quick Sort' &&
                              state.currentEventType == SortEventType.comparison &&
                              index == state.activeIndexB) {
                            cellColor = Colors.deepPurpleAccent;
                          } else {
                            cellColor = Colors.red;
                          }
                        } else if (isSorted) {
                          cellColor = Colors.green;
                        }

                        final hasBackground = cellColor != null;

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
                                color: cellColor ??
                                    Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                  color: cellColor ??
                                      Theme.of(context).colorScheme.outline,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                '${state.array[index]}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: hasBackground ? Colors.white : null,
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

                  Builder(
                    builder: (context) {
                      final maxDelay = isMergeSort ? 2000.0 : 1000.0;
                      final currentSpeed = state.speed.clamp(10.0, maxDelay);

                      return Row(
                        children: [
                          const Icon(Icons.speed),

                          Expanded(
                            child: Slider(
                              min: 10.0,
                              max: maxDelay,
                              value: (maxDelay + 10.0) - currentSpeed,
                              onChanged: (value) {
                                controller.setSpeed((maxDelay + 10.0) - value);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // --------------------------------------------------
                  // New array
                  // --------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.generateArray(isMergeSort ? 8 : 20);
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