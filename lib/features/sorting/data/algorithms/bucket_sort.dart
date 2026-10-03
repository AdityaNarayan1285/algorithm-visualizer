import 'dart:math';

import '../../domain/sort_algo.dart';
import '../../domain/sort_event.dart';

class BucketSort implements SortAlgorithm {
  @override
  String get name => 'Bucket Sort';

  @override
  List<SortEvent> execute(List<int> input) {
    final array = List<int>.from(input);
    final events = <SortEvent>[];
    final n = array.length;

    if (n <= 1) {
      if (n == 1) {
        events.add(
          SortEvent(
            type: SortEventType.mark,
            indexA: 0,
            indexB: -1,
            arraySnapshot: List<int>.from(array),
          ),
        );
      }
      events.add(
        SortEvent(
          type: SortEventType.done,
          indexA: -1,
          indexB: -1,
          arraySnapshot: List<int>.from(array),
        ),
      );
      return events;
    }

    const bucketCount = 5;
    int minVal = array.first;
    int maxVal = array.first;
    for (final val in array) {
      minVal = min(minVal, val);
      maxVal = max(maxVal, val);
    }

    final range = maxVal - minVal + 1;
    final buckets = List<List<int>>.generate(bucketCount, (_) => []);

    int getBucketIndex(int val) {
      if (range == 0) return 0;
      final idx = ((val - minVal) * bucketCount) ~/ range;
      return idx.clamp(0, bucketCount - 1);
    }

    // 1. Distribute elements into buckets
    for (int i = 0; i < n; i++) {
      final val = array[i];
      final bIdx = getBucketIndex(val);
      buckets[bIdx].add(val);

      events.add(
        SortEvent(
          type: SortEventType.distribute,
          indexA: i,
          indexB: bIdx,
          arraySnapshot: List<int>.from(array),
        ),
      );
    }

    // 2. Sort individual buckets using Insertion Sort
    for (int b = 0; b < bucketCount; b++) {
      final bucket = buckets[b];
      for (int i = 1; i < bucket.length; i++) {
        final key = bucket[i];
        int j = i - 1;

        while (j >= 0 && bucket[j] > key) {
          events.add(
            SortEvent(
              type: SortEventType.comparison,
              indexA: b, // Bucket index
              indexB: j, // Element index in bucket
              arraySnapshot: List<int>.from(array),
            ),
          );

          bucket[j + 1] = bucket[j];
          j--;
        }
        bucket[j + 1] = key;
      }
    }

    // 3. Gather elements from buckets back into the original array
    int writeIndex = 0;
    for (int b = 0; b < bucketCount; b++) {
      final bucket = buckets[b];
      for (int i = 0; i < bucket.length; i++) {
        array[writeIndex] = bucket[i];

        events.add(
          SortEvent(
            type: SortEventType.gather,
            indexA: writeIndex,
            indexB: b, // Bucket index
            arraySnapshot: List<int>.from(array),
          ),
        );

        events.add(
          SortEvent(
            type: SortEventType.mark,
            indexA: writeIndex,
            indexB: -1,
            arraySnapshot: List<int>.from(array),
          ),
        );

        writeIndex++;
      }
    }

    // 4. Final completion
    events.add(
      SortEvent(
        type: SortEventType.done,
        indexA: -1,
        indexB: -1,
        arraySnapshot: List<int>.from(array),
      ),
    );

    return events;
  }
}
