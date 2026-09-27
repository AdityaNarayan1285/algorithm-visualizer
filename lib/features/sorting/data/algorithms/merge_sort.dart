
import '../../domain/sort_algo.dart';
import '../../domain/sort_event.dart';

class MergeSort implements SortAlgorithm {
  @override
  String get name => 'Merge Sort';

  @override
  List<SortEvent> execute(List<int> input) {
    final array = List<int>.from(input);
    final events = <SortEvent>[];
    final temp = List<int>.filled(array.length, 0);

    void merge(int left, int middle, int right) {
      // Copy the current range into the temporary array.
      for (int i = left; i <= right; i++) {
        temp[i] = array[i];
      }

      int i = left;
      int j = middle + 1;
      int k = left;

      // Merge the two sorted halves.
      while (i <= middle && j <= right) {
        events.add(
          SortEvent(
            type: SortEventType.comparison,
            indexA: i,
            indexB: j,
            arraySnapshot: List<int>.from(array),
          ),
        );

        if (temp[i] <= temp[j]) {
          array[k] = temp[i];
          i++;
        } else {
          array[k] = temp[j];
          j++;
        }

        events.add(
          SortEvent(
            type: SortEventType.merge,
            indexA: k,
            indexB: -1,
            arraySnapshot: List<int>.from(array),
          ),
        );

        k++;
      }

      // Copy remaining elements from the left half.
      while (i <= middle) {
        array[k] = temp[i];

        events.add(
          SortEvent(
            type: SortEventType.merge,
            indexA: k,
            indexB: -1,
            arraySnapshot: List<int>.from(array),
          ),
        );

        i++;
        k++;
      }

      // Copy remaining elements from the right half.
      while (j <= right) {
        array[k] = temp[j];

        events.add(
          SortEvent(
            type: SortEventType.merge,
            indexA: k,
            indexB: -1,
            arraySnapshot: List<int>.from(array),
          ),
        );

        j++;
        k++;
      }
    }

    void mergeSort(int left, int right) {
      // Base case: a single element is already sorted.
      if (left >= right) {
        return;
      }

      final middle = left + (right - left) ~/ 2;

      // Record that this range is being split.
      events.add(
        SortEvent(
          type: SortEventType.split,
          indexA: left,
          indexB: right,
          arraySnapshot: List<int>.from(array),
        ),
      );

      // Sort the left half.
      mergeSort(left, middle);

      // Sort the right half.
      mergeSort(middle + 1, right);

      // Merge the two sorted halves.
      merge(left, middle, right);
    }

    if (array.isNotEmpty) {
      mergeSort(0, array.length - 1);
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
