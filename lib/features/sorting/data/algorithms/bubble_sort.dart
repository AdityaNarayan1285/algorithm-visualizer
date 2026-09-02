import '../../domain/sort_algo.dart';
import '../../domain/sort_event.dart';

class BubbleSort implements SortAlgorithm {
  @override
  String get name => 'Bubble Sort';

  @override
  List<SortEvent> execute(List<int> input) {
    // Work on a copy so that the original array isn't modified.
    final array = List<int>.from(input);

    // Stores every comparison, swap, mark, and completion event.
    final events = <SortEvent>[];

    for (int i = 0; i < array.length - 1; i++) {
      for (int j = 0; j < array.length - i - 1; j++) {
        // Record the comparison.
        events.add(
          SortEvent(
            type: SortEventType.comparison,
            indexA: j,
            indexB: j + 1,
            arraySnapshot: List<int>.from(array),
          ),
        );

        // Swap if the elements are in the wrong order.
        if (array[j] > array[j + 1]) {
          final temp = array[j];
          array[j] = array[j + 1];
          array[j + 1] = temp;

          // Record the swap.
          events.add(
            SortEvent(
              type: SortEventType.swap,
              indexA: j,
              indexB: j + 1,
              arraySnapshot: List<int>.from(array),
            ),
          );
        }
      }

      // The largest remaining element has reached its final position.
      final sortedIndex = array.length - i - 1;

      events.add(
        SortEvent(
          type: SortEventType.mark,
          indexA: sortedIndex,
          indexB: -1,
          arraySnapshot: List<int>.from(array),
        ),
      );
    }

    // The first element is also finalized.
    if (array.isNotEmpty) {
      events.add(
        SortEvent(
          type: SortEventType.mark,
          indexA: 0,
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