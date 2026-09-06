import '../../domain/sort_algo.dart';
import '../../domain/sort_event.dart';

class InsertionSort implements SortAlgorithm {
  @override
  String get name => 'Insertion Sort';

  @override
  List<SortEvent> execute(List<int> input) {
    final array = List<int>.from(input);
    final events = <SortEvent>[];

    for (int i = 1; i < array.length; i++) {
      final key = array[i];
      int j = i - 1;

      while (j >= 0) {
        // Record comparison between the current element and the key.
        events.add(
          SortEvent(
            type: SortEventType.comparison,
            indexA: j,
            indexB: i,
            arraySnapshot: List<int>.from(array),
          ),
        );

        if (array[j] <= key) {
          break;
        }

        // Shift the larger element one position to the right.
        array[j + 1] = array[j];

        events.add(
          SortEvent(
            type: SortEventType.shift,
            indexA: j,
            indexB: j + 1,
            arraySnapshot: List<int>.from(array),
          ),
        );

        j--;
      }

      // Place the key into its correct position.
      array[j + 1] = key;

      events.add(
        SortEvent(
          type: SortEventType.insert,
          indexA: j + 1,
          indexB: -1,
          arraySnapshot: List<int>.from(array),
        ),
      );

      // Everything through this position is now sorted.
      for (int index = 0; index <= i; index++) {
        if (!events.any(
          (event) =>
              event.type == SortEventType.mark &&
              event.indexA == index,
        )) {
          events.add(
            SortEvent(
              type: SortEventType.mark,
              indexA: index,
              indexB: -1,
              arraySnapshot: List<int>.from(array),
            ),
          );
        }
      }
    }

    // Handle an empty or single-element array.
    if (array.length <= 1 && array.isNotEmpty) {
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