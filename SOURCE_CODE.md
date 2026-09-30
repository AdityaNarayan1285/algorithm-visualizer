# Algorithm Learning Platform — Source Code

> Generated from the current `lib` directory uploaded for this project.
> File paths below are relative to `lib/`.

## Contents

- [`lib/app/app.dart`](#libappappdart)
- [`lib/app/router.dart`](#libapprouterdart)
- [`lib/app/theme.dart`](#libappthemedart)
- [`lib/features/comparison/presentation/comparison_page.dart`](#libfeaturescomparisonpresentationcomparisonpagedart)
- [`lib/features/home/presentation/home_page.dart`](#libfeatureshomepresentationhomepagedart)
- [`lib/features/pathfinding/presentation/pathfinding_page.dart`](#libfeaturespathfindingpresentationpathfindingpagedart)
- [`lib/features/sorting/data/algorithms/bubble_sort.dart`](#libfeaturessortingdataalgorithmsbubblesortdart)
- [`lib/features/sorting/data/algorithms/insertion_sort.dart`](#libfeaturessortingdataalgorithmsinsertionsortdart)
- [`lib/features/sorting/data/algorithms/selection_sort.dart`](#libfeaturessortingdataalgorithmsselectionsortdart)
- [`lib/features/sorting/domain/sort_algo.dart`](#libfeaturessortingdomainsortalgodart)
- [`lib/features/sorting/domain/sort_event.dart`](#libfeaturessortingdomainsorteventdart)
- [`lib/features/sorting/domain/sort_state.dart`](#libfeaturessortingdomainsortstatedart)
- [`lib/features/sorting/presentation/sort_controller.dart`](#libfeaturessortingpresentationsortcontrollerdart)
- [`lib/features/sorting/presentation/sort_providers.dart`](#libfeaturessortingpresentationsortprovidersdart)
- [`lib/features/sorting/presentation/sorting_algorithms_page.dart`](#libfeaturessortingpresentationsortingalgorithmspagedart)
- [`lib/features/sorting/presentation/sorting_page.dart`](#libfeaturessortingpresentationsortingpagedart)
- [`lib/features/sorting/presentation/widgets/sort_bars_painter.dart`](#libfeaturessortingpresentationwidgetssortbarspainterdart)
- [`lib/main.dart`](#libmaindart)

---

## `lib/app/app.dart`

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'theme.dart';

class AlgorithmVisualizerApp extends StatelessWidget {
  const AlgorithmVisualizerApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      routerConfig: router,
    );
  }
}
```

---

## `lib/app/router.dart`

```dart
import 'package:go_router/go_router.dart';

import '../features/comparison/presentation/comparison_page.dart';
import '../features/pathfinding/presentation/pathfinding_page.dart';
import '../features/sorting/presentation/sorting_algorithms_page.dart';
import '../features/home/presentation/home_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage()
    ),

    GoRoute(
      path: '/sorting',
      builder: (context, state) => const SortingAlgorithmsPage(),
    ),

    GoRoute(
      path: '/pathfinding',
      builder: (context, state) => const PathfindingPage(),
    ),

    GoRoute(
      path: '/comparison',
      builder: (context, state) => const ComparisonPage(),
    ),
  ],
);
```

---

## `lib/app/theme.dart`

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  );
}
```

---

## `lib/features/comparison/presentation/comparison_page.dart`

```dart
import 'package:flutter/material.dart';

class ComparisonPage extends StatelessWidget {
  const ComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Comparison Page', style: TextStyle(fontSize: 28)),
      ),
    );
  }
}
```

---

## `lib/features/home/presentation/home_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Algorithm Visualizer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => context.go('/sorting'),
                child: const Text('Sorting Visualizer'),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () => context.go('/pathfinding'),
                child: const Text('Pathfinding Visualizer'),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () => context.go('/comparison'),
                child: const Text('Algorithm Comparison'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## `lib/features/pathfinding/presentation/pathfinding_page.dart`

```dart
import 'package:flutter/material.dart';

class PathfindingPage extends StatelessWidget {
  const PathfindingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Pathfinding Page', style: TextStyle(fontSize: 28)),
      ),
    );
  }
}
```

---

## `lib/features/sorting/data/algorithms/bubble_sort.dart`

```dart
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
```

---

## `lib/features/sorting/data/algorithms/insertion_sort.dart`

```dart
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
```

---

## `lib/features/sorting/data/algorithms/selection_sort.dart`

```dart
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
```

---

## `lib/features/sorting/domain/sort_algo.dart`

```dart
import 'sort_event.dart';

abstract class SortAlgorithm {
  String get name;

  List<SortEvent> execute(List<int> array);
}
```

---

## `lib/features/sorting/domain/sort_event.dart`

```dart
enum SortEventType {
  comparison,
  swap,
  shift,
  insert,
  mark,
  unmark,
  done,
}

class SortEvent {
  final SortEventType type;
  final int indexA;
  final int indexB;
  final List<int> arraySnapshot;

  const SortEvent({
    required this.type,
    required this.indexA,
    required this.indexB,
    required this.arraySnapshot,
  });
}
```

---

## `lib/features/sorting/domain/sort_state.dart`

```dart
import 'sort_event.dart';

enum SortStatus {
  idle,
  running,
  paused,
  completed,
}

class SortState {
  final List<int> array;
  final List<SortEvent> events;
  final int currentStep;
  final SortStatus status;
  final int activeIndexA;
  final int activeIndexB;
  final List<int> sortedIndices;
  final String algorithmName;
  final double speed;
  final SortEventType? currentEventType;

  const SortState({
    required this.array,
    required this.events,
    required this.currentStep,
    required this.status,
    required this.activeIndexA,
    required this.activeIndexB,
    required this.sortedIndices,
    required this.algorithmName,
    required this.speed,
    this.currentEventType,
  });

  factory SortState.initial() {
    return const SortState(
      array: [],
      events: [],
      currentStep: 0,
      status: SortStatus.idle,
      activeIndexA: -1,
      activeIndexB: -1,
      sortedIndices: [],
      algorithmName: 'Bubble Sort',
      speed: 200,
    );
  }

  SortState copyWith({
    List<int>? array,
    List<SortEvent>? events,
    int? currentStep,
    SortStatus? status,
    int? activeIndexA,
    int? activeIndexB,
    List<int>? sortedIndices,
    String? algorithmName,
    double? speed,
    SortEventType? currentEventType,
  }) {
    return SortState(
      array: array ?? this.array,
      events: events ?? this.events,
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      activeIndexA: activeIndexA ?? this.activeIndexA,
      activeIndexB: activeIndexB ?? this.activeIndexB,
      sortedIndices: sortedIndices ?? this.sortedIndices,
      algorithmName: algorithmName ?? this.algorithmName,
      speed: speed ?? this.speed,
      currentEventType: currentEventType ?? this.currentEventType,
    );
  }
}
```

---

## `lib/features/sorting/presentation/sort_controller.dart`

```dart
import 'dart:async';
import 'dart:math';

import 'package:state_notifier/state_notifier.dart';

import '../domain/sort_algo.dart';
import '../domain/sort_event.dart';
import '../domain/sort_state.dart';
import '../data/algorithms/bubble_sort.dart';

class SortController extends StateNotifier<SortState> {
  Timer? _timer;

  SortAlgorithm _algorithm = BubbleSort();

  SortController() : super(SortState.initial());

  // ----------------------------------------------------------
  // Generate a new random array
  // ----------------------------------------------------------

  void generateArray(int size) {
    _stopTimer();

    final random = Random();

    final array = List.generate(
      size,
      (_) => random.nextInt(100) + 1,
    );

    state = SortState.initial().copyWith(
      array: array,
      algorithmName: _algorithm.name,
      speed: state.speed,
    );
  }

  // ----------------------------------------------------------
  // Select sorting algorithm
  // ----------------------------------------------------------

  void setAlgorithm(SortAlgorithm algorithm) {
    _stopTimer();

    _algorithm = algorithm;

    state = state.copyWith(
      algorithmName: algorithm.name,
      events: [],
      currentStep: 0,
      status: SortStatus.idle,
      activeIndexA: -1,
      activeIndexB: -1,
      sortedIndices: [],
      currentEventType: null,
    );
  }

  // ----------------------------------------------------------
  // Calculate sorted indices from visualization events
  // ----------------------------------------------------------

  List<int> _getSortedIndicesAtStep(
    List<SortEvent> events,
    int step,
  ) {
    final sortedIndices = <int>{};

    for (int i = 0; i <= step && i < events.length; i++) {
      final event = events[i];

      if (event.type == SortEventType.mark) {
        // mark uses indexA as the finalized position.
        sortedIndices.add(event.indexA);
      } else if (event.type == SortEventType.unmark) {
        // unmark removes the finalized position.
        sortedIndices.remove(event.indexA);
      } else if (event.type == SortEventType.done) {
        // Once the algorithm is complete, every position is sorted.
        for (int index = 0; index < event.arraySnapshot.length; index++) {
          sortedIndices.add(index);
        }
      }
    }

    final result = sortedIndices.toList();
    result.sort();

    return result;
  }

  // ----------------------------------------------------------
  // Play sorting animation
  // ----------------------------------------------------------

  void play() {
    // Don't start another timer if already running.
    if (state.status == SortStatus.running) {
      return;
    }

    // Generate events if they don't exist yet.
    if (state.events.isEmpty) {
      final events = _algorithm.execute(state.array);

      state = state.copyWith(
        events: events,
        currentStep: 0,
        sortedIndices: _getSortedIndicesAtStep(events, 0),
      );
    }

    // Nothing to play.
    if (state.events.isEmpty) {
      return;
    }

    state = state.copyWith(
      status: SortStatus.running,
    );

    _startTimer();
  }

  // ----------------------------------------------------------
  // Start timer
  // ----------------------------------------------------------

  void _startTimer() {
    _stopTimer();

    _timer = Timer.periodic(
      Duration(milliseconds: state.speed.round()),
      (_) {
        _advanceStep();
      },
    );
  }

  // ----------------------------------------------------------
  // Advance to next event
  // ----------------------------------------------------------

  void _advanceStep() {
    if (state.currentStep >= state.events.length - 1) {
      _stopTimer();

      final lastEvent = state.events.last;

      state = state.copyWith(
        currentStep: state.events.length - 1,
        status: SortStatus.completed,
        array: lastEvent.arraySnapshot,
        activeIndexA: lastEvent.indexA,
        activeIndexB: lastEvent.indexB,
        sortedIndices: _getSortedIndicesAtStep(
          state.events,
          state.events.length - 1,
        ),
      );

      return;
    }

    final nextStep = state.currentStep + 1;
    final event = state.events[nextStep];

    state = state.copyWith(
      currentStep: nextStep,
      array: event.arraySnapshot,
      activeIndexA: event.indexA,
      activeIndexB: event.indexB,
      currentEventType: event.type,
      sortedIndices: _getSortedIndicesAtStep(
        state.events,
        nextStep,
      ),
    );

    if (event.type == SortEventType.done) {
      _stopTimer();

      state = state.copyWith(
        status: SortStatus.completed,
      );
    }
  }

  // ----------------------------------------------------------
  // Pause sorting
  // ----------------------------------------------------------

  void pause() {
    if (state.status != SortStatus.running) {
      return;
    }

    _stopTimer();

    state = state.copyWith(
      status: SortStatus.paused,
    );
  }

  // ----------------------------------------------------------
  // Step forward manually
  // ----------------------------------------------------------

  void stepForward() {
    _stopTimer();

    if (state.events.isEmpty) {
      final events = _algorithm.execute(state.array);

      state = state.copyWith(
        events: events,
        currentStep: 0,
        sortedIndices: _getSortedIndicesAtStep(events, 0),
      );
    }

    if (state.currentStep >= state.events.length - 1) {
      return;
    }

    final nextStep = state.currentStep + 1;
    final event = state.events[nextStep];

    state = state.copyWith(
      currentStep: nextStep,
      array: event.arraySnapshot,
      activeIndexA: event.indexA,
      activeIndexB: event.indexB,
      currentEventType: event.type,
      sortedIndices: _getSortedIndicesAtStep(
        state.events,
        nextStep,
      ),
      status: event.type == SortEventType.done
          ? SortStatus.completed
          : SortStatus.paused,
    );
  }

  // ----------------------------------------------------------
  // Step backward manually
  // ----------------------------------------------------------

  void stepBackward() {
    _stopTimer();

    if (state.events.isEmpty) {
      return;
    }

    if (state.currentStep <= 0) {
      return;
    }

    final previousStep = state.currentStep - 1;
    final event = state.events[previousStep];

    state = state.copyWith(
      currentStep: previousStep,
      array: event.arraySnapshot,
      activeIndexA: event.indexA,
      activeIndexB: event.indexB,
      currentEventType: event.type,
      sortedIndices: _getSortedIndicesAtStep(
        state.events,
        previousStep,
      ),
      status: SortStatus.paused,
    );
  }

  // ----------------------------------------------------------
  // Reset sorting
  // ----------------------------------------------------------

  void reset() {
    _stopTimer();

    state = state.copyWith(
      currentStep: 0,
      status: SortStatus.idle,
      events: [],
      activeIndexA: -1,
      activeIndexB: -1,
      sortedIndices: [],
      currentEventType: null,
    );
  }

  // ----------------------------------------------------------
  // Change animation speed
  // ----------------------------------------------------------

  void setSpeed(double milliseconds) {
    state = state.copyWith(
      speed: milliseconds,
    );

    // Restart timer with new speed if currently playing.
    if (state.status == SortStatus.running) {
      _startTimer();
    }
  }

  // ----------------------------------------------------------
  // Stop timer
  // ----------------------------------------------------------

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // ----------------------------------------------------------
  // Cleanup
  // ----------------------------------------------------------

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
```

---

## `lib/features/sorting/presentation/sort_providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../domain/sort_event.dart';
import '../domain/sort_state.dart';
import 'sort_controller.dart';

final sortControllerProvider =
    StateNotifierProvider<SortController, SortState>((ref) {
  return SortController();
});

final currentArrayProvider = Provider<List<int>>((ref) {
  return ref.watch(sortControllerProvider).array;
});

final statisticsProvider = Provider<Map<String, int>>((ref) {
  final state = ref.watch(sortControllerProvider);

  int comparisons = 0;
  int swaps = 0;

  for (int i = 0; i <= state.currentStep; i++) {
    if (i >= state.events.length) {
      break;
    }

    final event = state.events[i];

    if (event.type == SortEventType.comparison) {
      comparisons++;
    } else if (event.type == SortEventType.swap) {
      swaps++;
    }
  }

  return {
    'comparisons': comparisons,
    'swaps': swaps,
  };
});
```

---

## `lib/features/sorting/presentation/sorting_algorithms_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/algorithms/bubble_sort.dart';
import '../data/algorithms/insertion_sort.dart';
import '../data/algorithms/selection_sort.dart';
import 'sort_providers.dart';
import 'sorting_page.dart';

class SortingAlgorithmsPage extends ConsumerWidget {
  const SortingAlgorithmsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorting Algorithms'),
      ),

      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _AlgorithmCard(
            name: 'Bubble Sort',
            description:
                'Compare adjacent elements and swap them.',
            bestTime: 'O(n)',
            averageTime: 'O(n²)',
            worstTime: 'O(n²)',
            spaceComplexity: 'O(1)',
            onTap: () {
              ref
                  .read(sortControllerProvider.notifier)
                  .setAlgorithm(BubbleSort());

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SortingPage(),
                ),
              );
            },
          ),

          _AlgorithmCard(
            name: 'Selection Sort',
            description:
                'Repeatedly select the smallest element.',
            bestTime: 'O(n²)',
            averageTime: 'O(n²)',
            worstTime: 'O(n²)',
            spaceComplexity: 'O(1)',
            onTap: () {
              ref
                  .read(sortControllerProvider.notifier)
                  .setAlgorithm(SelectionSort());

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SortingPage(),
                ),
              );
            },
          ),

          _AlgorithmCard(
            name: 'Insertion Sort',
            description:
                'Build sorted array one element at a time.',
            bestTime: 'O(n)',
            averageTime: 'O(n²)',
            worstTime: 'O(n²)',
            spaceComplexity: 'O(1)',
            onTap: () {
              ref
                  .read(sortControllerProvider.notifier)
                  .setAlgorithm(InsertionSort());

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SortingPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AlgorithmCard extends StatelessWidget {
  final String name;
  final String description;

  final String bestTime;
  final String averageTime;
  final String worstTime;
  final String spaceComplexity;

  final VoidCallback onTap;

  const _AlgorithmCard({
    required this.name,
    required this.description,
    required this.bestTime,
    required this.averageTime,
    required this.worstTime,
    required this.spaceComplexity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.bar_chart,
                size: 40,
              ),

              const SizedBox(height: 16),

              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 8),

              Text(description),

              const SizedBox(height: 16),

              const Text(
                'Time Complexity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text('Best: $bestTime'),
              Text('Average: $averageTime'),
              Text('Worst: $worstTime'),

              const SizedBox(height: 12),

              const Text(
                'Space Complexity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(spaceComplexity),

              const Spacer(),

              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## `lib/features/sorting/presentation/sorting_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/sort_event.dart';
import '../domain/sort_state.dart';
import 'sort_providers.dart';
import 'widgets/sort_bars_painter.dart';

class SortingPage extends ConsumerWidget {
  const SortingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sortControllerProvider);

    // Generate the initial array when the page opens.
    if (state.array.isEmpty) {
      Future.microtask(() {
        ref
            .read(sortControllerProvider.notifier)
            .generateArray(20);
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
          // Sorting bars
          // --------------------------------------------------

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CustomPaint(
                painter: SortBarsPainter(
                  array: state.array,
                  activeIndexA: state.activeIndexA,
                  activeIndexB: state.activeIndexB,
                  sortedIndices: state.sortedIndices,
                  maxValue: 100,
                  currentEventType: state.currentEventType,
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
                                color: isActive
                                    ? (state.currentEventType ==
                                                SortEventType
                                                    .insert &&
                                            index ==
                                                state
                                                    .activeIndexA
                                        ? Colors.amber
                                        : Colors.red)
                                    : isSorted
                                        ? Colors.green
                                        : Theme.of(context)
                                            .colorScheme
                                            .surface,
                                border: Border.all(
                                  color: isActive
                                      ? (state.currentEventType ==
                                                  SortEventType
                                                      .insert &&
                                              index ==
                                                  state
                                                      .activeIndexA
                                          ? Colors.amber
                                          : Colors.red)
                                      : isSorted
                                          ? Colors.green
                                          : Theme.of(context)
                                              .colorScheme
                                              .outline,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                '${state.array[index]}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isActive || isSorted
                                      ? Colors.white
                                      : null,
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

                  Row(
                    children: [
                      const Icon(Icons.speed),

                      Expanded(
                        child: Slider(
                          min: 10,
                          max: 500,
                          value: 510 - state.speed.clamp(10, 500),
                          onChanged: (value) {
                            controller.setSpeed(510 - value);
                          }
                        ),
                      ),
                    ],
                  ),

                  // --------------------------------------------------
                  // New array
                  // --------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.generateArray(20);
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
```

---

## `lib/features/sorting/presentation/widgets/sort_bars_painter.dart`

```dart
import 'package:flutter/material.dart';

import '../../domain/sort_event.dart';

class SortBarsPainter extends CustomPainter {
  final List<int> array;
  final int activeIndexA;
  final int activeIndexB;
  final List<int> sortedIndices;
  final int maxValue;
  final SortEventType? currentEventType;

  const SortBarsPainter({
    required this.array,
    required this.activeIndexA,
    required this.activeIndexB,
    required this.sortedIndices,
    required this.maxValue,
    this.currentEventType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (array.isEmpty) {
      return;
    }

    final barWidth = size.width / array.length;
    final paint = Paint();

    for (int i = 0; i < array.length; i++) {
      final barHeight =
          (array[i] / maxValue) * size.height;

      final isActive =
          i == activeIndexA || i == activeIndexB;

      final isSorted = sortedIndices.contains(i);

      // Active indices take priority over sorted indices.
      if (isActive) {
        // Use amber for the insert position, red for everything else.
        if (currentEventType == SortEventType.insert &&
            i == activeIndexA) {
          paint.color = Colors.amber;
        } else {
          paint.color = Colors.red;
        }
      } else if (isSorted) {
        paint.color = Colors.green;
      } else {
        paint.color = Colors.blue;
      }

      final rect = Rect.fromLTWH(
        i * barWidth,
        size.height - barHeight,
        barWidth - 2,
        barHeight,
      );

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SortBarsPainter oldDelegate) {
    return true;
  }
}
```

---

## `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/router.dart';

void main() {
  runApp(
    ProviderScope(
      child: AlgorithmVisualizerApp(
        router: appRouter
      )
    )
  );
}
```

---
