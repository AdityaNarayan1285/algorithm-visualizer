import '../../domain/sort_algo.dart';
import '../../domain/sort_event.dart';

class HeapSort implements SortAlgorithm {
  @override
  String get name => 'Heap Sort';

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

    void heapify(int heapSize, int i) {
      int largest = i;
      final left = 2 * i + 1;
      final right = 2 * i + 2;

      // Check left child
      if (left < heapSize) {
        events.add(
          SortEvent(
            type: SortEventType.comparison,
            indexA: i,
            indexB: left,
            arraySnapshot: List<int>.from(array),
          ),
        );
        if (array[left] > array[largest]) {
          largest = left;
        }
      }

      // Check right child
      if (right < heapSize) {
        events.add(
          SortEvent(
            type: SortEventType.comparison,
            indexA: largest,
            indexB: right,
            arraySnapshot: List<int>.from(array),
          ),
        );
        if (array[right] > array[largest]) {
          largest = right;
        }
      }

      // If largest is not root
      if (largest != i) {
        final temp = array[i];
        array[i] = array[largest];
        array[largest] = temp;

        events.add(
          SortEvent(
            type: SortEventType.swap,
            indexA: i,
            indexB: largest,
            arraySnapshot: List<int>.from(array),
          ),
        );

        // Recursively heapify the affected sub-tree
        heapify(heapSize, largest);
      }
    }

    // 1. Build max heap (rearrange array)
    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      heapify(n, i);
    }

    // 2. Extract elements one by one from heap
    for (int i = n - 1; i > 0; i--) {
      // Move current root to end
      final temp = array[0];
      array[0] = array[i];
      array[i] = temp;

      events.add(
        SortEvent(
          type: SortEventType.swap,
          indexA: 0,
          indexB: i,
          arraySnapshot: List<int>.from(array),
        ),
      );

      // Mark element at i as sorted
      events.add(
        SortEvent(
          type: SortEventType.mark,
          indexA: i,
          indexB: -1,
          arraySnapshot: List<int>.from(array),
        ),
      );

      // Call max heapify on reduced heap
      heapify(i, 0);
    }

    // Mark index 0 as sorted
    events.add(
      SortEvent(
        type: SortEventType.mark,
        indexA: 0,
        indexB: -1,
        arraySnapshot: List<int>.from(array),
      ),
    );

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
