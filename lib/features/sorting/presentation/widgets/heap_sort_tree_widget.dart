import 'package:flutter/material.dart';

import '../../../../core/widgets/algorithm_tree_widget.dart';
import '../../domain/sort_event.dart';
import '../../domain/sort_state.dart';

/// Visualization widget for Heap Sort rendering a binary heap tree
/// using the reusable [AlgorithmTreeWidget].
class HeapSortTreeWidget extends StatelessWidget {
  final SortState state;

  const HeapSortTreeWidget({
    super.key,
    required this.state,
  });

  int _calculateDepth(int index) {
    int depth = 0;
    int temp = index + 1;
    while (temp > 1) {
      temp >>= 1;
      depth++;
    }
    return depth;
  }

  @override
  Widget build(BuildContext context) {
    if (state.array.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final nodes = List.generate(state.array.length, (index) {
      final value = state.array[index];
      final depth = _calculateDepth(index);
      final parentId = index > 0 ? '${(index - 1) ~/ 2}' : null;

      final isSorted = state.sortedIndices.contains(index);
      final isActive =
          index == state.activeIndexA || index == state.activeIndexB;

      AlgorithmNodeStatus status = AlgorithmNodeStatus.idle;
      Color? customBorder;
      Color? customBg;

      if (isSorted) {
        status = AlgorithmNodeStatus.completed;
        customBorder = Colors.green;
        customBg = Colors.green.withValues(alpha: 0.15);
      } else if (isActive) {
        status = AlgorithmNodeStatus.active;
        if (state.currentEventType == SortEventType.swap) {
          customBorder = Colors.orangeAccent;
          customBg = Colors.orange.withValues(alpha: 0.18);
        } else {
          customBorder = Colors.redAccent;
          customBg = Colors.red.withValues(alpha: 0.18);
        }
      }

      return AlgorithmTreeNode(
        id: '$index',
        label: '[$index]',
        depth: depth,
        parentId: parentId,
        items: [value],
        status: status,
        customColor: customBorder,
        customBgColor: customBg,
      );
    });

    return AlgorithmTreeWidget(
      nodes: nodes,
      statusTitle: null,
      customNodeBuilder: (context, node) {
        final index = int.tryParse(node.id) ?? 0;
        final value = state.array.length > index ? state.array[index] : 0;
        final isSorted = state.sortedIndices.contains(index);
        final isActive =
            index == state.activeIndexA || index == state.activeIndexB;

        Color borderColor =
            node.customColor ?? Theme.of(context).colorScheme.outline;
        Color bgColor =
            node.customBgColor ?? Theme.of(context).colorScheme.surface;
        Color textColor = Theme.of(context).colorScheme.onSurface;

        if (isSorted) {
          textColor = Colors.greenAccent.shade700;
        } else if (isActive) {
          textColor = state.currentEventType == SortEventType.swap
              ? Colors.orangeAccent
              : Colors.redAccent;
        }

        final isEmphasized = isActive || isSorted;

        // Scale node size based on depth so tree fits nicely
        final nodeSize = node.depth > 2 ? 38.0 : 46.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: nodeSize,
          height: nodeSize,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: isActive ? 2.5 : (isSorted ? 2.0 : 1.2),
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: borderColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$value',
                style: TextStyle(
                  fontSize: node.depth > 2 ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color: isEmphasized ? textColor : null,
                ),
              ),
              Text(
                '#$index',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
