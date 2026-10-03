import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/sort_event.dart';
import '../../domain/sort_state.dart';

/// Interactive visualizer for Bucket Sort showing distribution, internal bucket sorting,
/// and sequential gathering of elements.
class BucketSortWidget extends StatelessWidget {
  final SortState state;

  const BucketSortWidget({
    super.key,
    required this.state,
  });

  static const int bucketCount = 5;

  static const List<Color> bucketColors = [
    Colors.tealAccent,
    Colors.cyanAccent,
    Colors.indigoAccent,
    Colors.purpleAccent,
    Colors.amberAccent,
  ];

  /// Reconstructs the live state of all 5 buckets at the current step.
  List<List<int>> _computeBucketsAtCurrentStep() {
    final buckets = List<List<int>>.generate(bucketCount, (_) => []);

    if (state.events.isEmpty || state.currentStep < 0) {
      return buckets;
    }

    final initialArray = state.events.first.arraySnapshot;
    if (initialArray.isEmpty) return buckets;

    for (int s = 0; s <= state.currentStep && s < state.events.length; s++) {
      final event = state.events[s];
      if (event.type == SortEventType.distribute) {
        final val = event.arraySnapshot[event.indexA];
        final bIdx = event.indexB;
        if (bIdx >= 0 && bIdx < bucketCount) {
          buckets[bIdx].add(val);
        }
      }
    }

    // If we have reached phase 2 / 3, sort each bucket contents to reflect sorted state
    bool isSortingOrGathering = state.currentStep >= initialArray.length;
    if (isSortingOrGathering) {
      for (int b = 0; b < bucketCount; b++) {
        buckets[b].sort();
      }
    }

    return buckets;
  }

  String _getPhaseDescription() {
    if (state.status == SortStatus.completed) {
      return 'Phase 3 Complete: All buckets gathered into sorted array';
    }
    if (state.currentEventType == SortEventType.distribute) {
      return 'Phase 1: Distributing elements from array into corresponding buckets';
    } else if (state.currentEventType == SortEventType.comparison) {
      return 'Phase 2: Sorting elements inside each individual bucket';
    } else if (state.currentEventType == SortEventType.gather) {
      return 'Phase 3: Gathering sorted elements from buckets back into array';
    }
    return 'Bucket Sort: Scatter -> Sort -> Gather';
  }

  @override
  Widget build(BuildContext context) {
    if (state.array.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final buckets = _computeBucketsAtCurrentStep();
    final phaseText = _getPhaseDescription();

    // Determine value range labels for buckets
    int minVal = state.array.reduce(min);
    int maxVal = state.array.reduce(max);
    for (final ev in state.events) {
      if (ev.arraySnapshot.isNotEmpty) {
        minVal = min(minVal, ev.arraySnapshot.reduce(min));
        maxVal = max(maxVal, ev.arraySnapshot.reduce(max));
      }
    }

    final rangeStep = ((maxVal - minVal + 1) / bucketCount).ceil();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Phase Header Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.layers_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    phaseText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ],
            ),
          ),

          // 5 Bucket Containers
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(bucketCount, (bIdx) {
                  final bucketItems = buckets[bIdx];
                  final accentColor = bucketColors[bIdx % bucketColors.length];

                  final isCurrentActiveBucket =
                      (state.currentEventType == SortEventType.distribute &&
                              state.activeIndexB == bIdx) ||
                          (state.currentEventType == SortEventType.comparison &&
                              state.activeIndexA == bIdx) ||
                          (state.currentEventType == SortEventType.gather &&
                              state.activeIndexB == bIdx);

                  final rangeStart = minVal + bIdx * rangeStep;
                  final rangeEnd = min(maxVal, rangeStart + rangeStep - 1);
                  final rangeLabel = '$rangeStart–$rangeEnd';

                  // Width to fit 2-3 per row responsively
                  final cardWidth = constraints.maxWidth > 500
                      ? (constraints.maxWidth - 32) / 3
                      : (constraints.maxWidth - 16) / 2;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: cardWidth,
                    constraints: const BoxConstraints(minHeight: 110),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isCurrentActiveBucket
                          ? accentColor.withValues(alpha: 0.15)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isCurrentActiveBucket
                            ? accentColor
                            : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                        width: isCurrentActiveBucket ? 2.0 : 1.0,
                      ),
                      boxShadow: isCurrentActiveBucket
                          ? [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.35),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bucket Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.shopping_basket_outlined,
                                  size: 16,
                                  color: accentColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Bucket $bIdx',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isCurrentActiveBucket
                                        ? accentColor
                                        : Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                rangeLabel,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        const Divider(height: 1),
                        const SizedBox(height: 8),

                        // Bucket Items
                        if (bucketItems.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                'Empty',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          )
                        else
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: bucketItems.map((val) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isCurrentActiveBucket
                                      ? accentColor.withValues(alpha: 0.25)
                                      : Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isCurrentActiveBucket
                                        ? accentColor
                                        : Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Text(
                                  '$val',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isCurrentActiveBucket
                                        ? Theme.of(context).colorScheme.onSurface
                                        : null,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
