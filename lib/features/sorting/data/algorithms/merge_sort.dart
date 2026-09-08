```dart
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
      for (int index = left; index <= right; index++) {
        temp[index] = array[index];
      }

      int i = left;
      int j = middle + 1;
      int k = left;

      // Merge while both halves still have elements.
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

          events.add(
            SortEvent(
              type: SortEventType.merge,
              indexA: i,
              indexB: k,
              arraySnapshot: List<int>.from(array),
            ),
          );

          i++;
        } else {
          array[k] = temp[j];

          events.add(
            SortEvent(
              type: SortEventType.merge,
              indexA: j,
              indexB: k,
              arraySnapshot: List<int>.from(array),
            ),
          );

          j++;
        }

        k++;
      }

      // Copy remaining elements from the left half.
      while (i <= middle) {
        array[k] = temp[i];

        events.add(
          SortEvent(
            type: SortEventType.merge,
            indexA: i,
            indexB: k,
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
            indexA: j,
            indexB: k,
            arraySnapshot: List<int>.from(array),
          ),
        );

        j++;
        k++;
      }
    }

    void mergeSort(int left, int right) {
      if (left >= right) {
        return;
      }

      final middle = (left + right) ~/ 2;

      // Record the range being split.
      events.add(
        SortEvent(
          type: SortEventType.split,
          indexA: left,
          indexB: right,
          arraySnapshot: List<int>.from(array),
        ),
      );

      mergeSort(left, middle);
      mergeSort(middle + 1, right);

      merge(left, middle, right);
    }

    if (array.length > 1) {
      mergeSort(0, array.length - 1);
    }

    // Only mark elements after the entire array is sorted.
    for (int index = 0; index < array.length; index++) {
      events.add(
        SortEvent(
          type: SortEventType.mark,
          indexA: index,
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
}
```
