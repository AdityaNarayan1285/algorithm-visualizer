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