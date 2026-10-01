import 'package:flutter/material.dart';

import '../../features/sorting/domain/sort_event.dart';
import '../../features/sorting/domain/sort_state.dart';

/// A status text window header displaying real-time step information for algorithms.
class AlgorithmStatusBanner extends StatelessWidget {
  final SortState state;

  const AlgorithmStatusBanner({
    super.key,
    required this.state,
  });

  String _getStatusText() {
    if (state.status == SortStatus.completed) {
      return '${state.algorithmName} Completed! Array is fully sorted.';
    }

    if (state.status == SortStatus.idle && state.events.isEmpty) {
      return 'Ready to start ${state.algorithmName}. Tap Play or Step forward.';
    }

    final eventType = state.currentEventType;
    final a = state.activeIndexA;
    final b = state.activeIndexB;

    if (eventType == SortEventType.pivot && a >= 0 && a < state.array.length) {
      return 'Selected index $a (${state.array[a]}) as pivot element';
    } else if (eventType == SortEventType.comparison && a >= 0 && a < state.array.length && b >= 0 && b < state.array.length) {
      if (state.algorithmName == 'Quick Sort') {
        return 'Comparing index $a (${state.array[a]}) with pivot at index $b (${state.array[b]})';
      }
      return 'Comparing index $a (${state.array[a]}) and index $b (${state.array[b]})';
    } else if (eventType == SortEventType.swap && a >= 0 && b >= 0) {
      return 'Swapping elements at index $a and index $b';
    } else if (eventType == SortEventType.shift && a >= 0 && b >= 0) {
      return 'Shifting element at index $a to index $b';
    } else if (eventType == SortEventType.insert && a >= 0) {
      return 'Inserting element at sorted position index $a';
    } else if (eventType == SortEventType.split && a >= 0 && b >= 0) {
      return 'Splitting array range [$a..$b] into 2 halves';
    } else if (eventType == SortEventType.merge && a >= 0) {
      return 'Merging element into index $a';
    } else if (eventType == SortEventType.mark && a >= 0) {
      return 'Position index $a is finalized in its sorted position';
    }

    return '${state.algorithmName} step ${state.currentStep + 1} of ${state.events.length}';
  }

  @override
  Widget build(BuildContext context) {
    final statusText = _getStatusText();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              statusText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
