import '../../domain/sort_algo.dart';
import '../../domain/sort_event.dart';

class QuickSort implements SortAlgorithm {
  @override
  String get name => 'Quick Sort';

  @override
  List<SortEvent> execute(List<int> input) {
    final array = List<int>.from(input);
    final events = <SortEvent>[];

    if (array.isEmpty) {
      return events;
    }

    void quickSort(int low, int high) {
      if (low > high) {
        return;
      }

      if (low == high) {
        events.add(
          SortEvent(
            type: SortEventType.mark,
            indexA: low,
            indexB: -1,
            arraySnapshot: List<int>.from(array),
          ),
        );
        return;
      }

      // 1. Highlight the pivot element (last element in current subarray)
      final pivotIndex = high;
      events.add(
        SortEvent(
          type: SortEventType.pivot,
          indexA: pivotIndex,
          indexB: -1,
          arraySnapshot: List<int>.from(array),
        ),
      );

      final pivotValue = array[pivotIndex];
      int i = low - 1;

      // 2. Lomuto Partitioning
      for (int j = low; j < high; j++) {
        // Compare array[j] with pivot
        events.add(
          SortEvent(
            type: SortEventType.comparison,
            indexA: j,
            indexB: pivotIndex,
            arraySnapshot: List<int>.from(array),
          ),
        );

        if (array[j] < pivotValue) {
          i++;
          if (i != j) {
            final temp = array[i];
            array[i] = array[j];
            array[j] = temp;

            events.add(
              SortEvent(
                type: SortEventType.swap,
                indexA: i,
                indexB: j,
                arraySnapshot: List<int>.from(array),
              ),
            );
          }
        }
      }

      // 3. Move pivot to its correct sorted position (i + 1)
      final sortedPivotIndex = i + 1;
      if (sortedPivotIndex != high) {
        final temp = array[sortedPivotIndex];
        array[sortedPivotIndex] = array[high];
        array[high] = temp;

        events.add(
          SortEvent(
            type: SortEventType.swap,
            indexA: sortedPivotIndex,
            indexB: high,
            arraySnapshot: List<int>.from(array),
          ),
        );
      }

      // Mark the pivot as sorted
      events.add(
        SortEvent(
          type: SortEventType.mark,
          indexA: sortedPivotIndex,
          indexB: -1,
          arraySnapshot: List<int>.from(array),
        ),
      );

      // 4. Recursively sort left and right partitions
      quickSort(low, sortedPivotIndex - 1);
      quickSort(sortedPivotIndex + 1, high);
    }

    quickSort(0, array.length - 1);

    // Final completion event
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
