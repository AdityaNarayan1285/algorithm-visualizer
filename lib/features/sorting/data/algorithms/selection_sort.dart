import '../../domain/sort_algo.dart';
import '../../domain/sort_event.dart';

class SelectionSort implements SortAlgorithm {
  @override
  String get name => 'Selection Sort';

  @override
  List<SortEvent> execute(List<int> input) {
    final array = List<int>.from(input);
    final events = <SortEvent>[];

    for (int i = 0; i < array.length - 1; i++) {
      // Assume the current position contains the minimum.
      int minIndex = i;

      for (int j = i + 1; j < array.length; j++) {
        // Record comparison.
        events.add(
          SortEvent(
            type: SortEventType.comparison,
            indexA: minIndex,
            indexB: j,
            arraySnapshot: List<int>.from(array),
          ),
        );

        // Found a smaller element.
        if (array[j] < array[minIndex]) {
          minIndex = j;
        }
      }

      // Swap the minimum element into its correct position.
      if (minIndex != i) {
        final temp = array[i];
        array[i] = array[minIndex];
        array[minIndex] = temp;

        // Record swap.
        events.add(
          SortEvent(
            type: SortEventType.swap,
            indexA: i,
            indexB: minIndex,
            arraySnapshot: List<int>.from(array),
          ),
        );
      }

      // Position i is now finalized.
      events.add(
        SortEvent(
          type: SortEventType.mark,
          indexA: i,
          indexB: -1,
          arraySnapshot: List<int>.from(array),
        ),
      );
    }

    // The final remaining position is also finalized.
    if (array.isNotEmpty) {
      events.add(
        SortEvent(
          type: SortEventType.mark,
          indexA: array.length - 1,
          indexB: -1,
          arraySnapshot: List<int>.from(array),
        ),
      );
    }

    // Record completion.
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