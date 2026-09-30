import 'package:flutter/material.dart';

import '../../../../core/widgets/algorithm_tree_widget.dart';
import '../../domain/sort_event.dart';
import '../../domain/sort_state.dart';

class TreeNode {
  final int id;
  final int left;
  final int right;
  final int depth;
  final int? parentId;

  TreeNode({
    required this.id,
    required this.left,
    required this.right,
    required this.depth,
    this.parentId,
  });
}

/// Specialized wrapper around generic [AlgorithmTreeWidget] for Merge Sort visualization.
class MergeSortTreeWidget extends StatelessWidget {
  final SortState state;

  const MergeSortTreeWidget({
    super.key,
    required this.state,
  });

  /// Recursively builds all tree nodes for an array range [0, length - 1]
  List<TreeNode> _buildTreeStructure(int length) {
    if (length <= 0) return [];

    final nodes = <TreeNode>[];
    int nextId = 0;

    void build(int left, int right, int depth, int? parentId) {
      final nodeId = nextId++;
      nodes.add(
        TreeNode(
          id: nodeId,
          left: left,
          right: right,
          depth: depth,
          parentId: parentId,
        ),
      );

      if (left < right) {
        final mid = left + (right - left) ~/ 2;
        build(left, mid, depth + 1, nodeId);
        build(mid + 1, right, depth + 1, nodeId);
      }
    }

    build(0, length - 1, 0, null);
    return nodes;
  }

  @override
  Widget build(BuildContext context) {
    if (state.array.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final treeNodes = _buildTreeStructure(state.array.length);
    final activeRange = _getActiveRange(state);

    // Convert internal tree nodes to generic AlgorithmTreeNode
    final genericNodes = treeNodes.map((node) {
      final rangeLength = node.right - node.left + 1;
      final label = rangeLength == 1 ? 'Index ${node.left}' : '[${node.left}..${node.right}]';

      bool isNodeSplitActive = false;
      bool isNodeActive = false;

      if (activeRange['type'] == 'split') {
        if (activeRange['left'] == node.left && activeRange['right'] == node.right) {
          isNodeSplitActive = true;
        }
      } else if (activeRange['type'] == 'active') {
        final a = activeRange['activeA'] as int?;
        final b = activeRange['activeB'] as int?;
        if ((a != null && a >= node.left && a <= node.right) ||
            (b != null && b >= node.left && b <= node.right)) {
          isNodeActive = true;
        }
      }

      AlgorithmNodeStatus status = AlgorithmNodeStatus.idle;
      Color? customBorder;
      Color? customBg;

      if (isNodeSplitActive) {
        status = AlgorithmNodeStatus.highlighted;
        customBorder = Colors.purpleAccent;
        customBg = Colors.purple.withValues(alpha: 0.15);
      } else if (isNodeActive) {
        status = AlgorithmNodeStatus.active;
        customBorder = state.currentEventType == SortEventType.merge
            ? Colors.orangeAccent
            : Colors.redAccent;
        customBg = customBorder.withValues(alpha: 0.12);
      } else if (state.status == SortStatus.completed) {
        status = AlgorithmNodeStatus.completed;
        customBorder = Colors.green;
        customBg = Colors.green.withValues(alpha: 0.08);
      }

      final rangeValues = List.generate(rangeLength, (i) {
        final idx = node.left + i;
        return idx < state.array.length ? state.array[idx] : 0;
      });

      return AlgorithmTreeNode(
        id: '${node.id}',
        label: label,
        depth: node.depth,
        parentId: node.parentId != null ? '${node.parentId}' : null,
        items: rangeValues,
        status: status,
        customColor: customBorder,
        customBgColor: customBg,
      );
    }).toList();

    return AlgorithmTreeWidget(
      nodes: genericNodes,
      statusTitle: null,
      customNodeBuilder: (context, genericNode) {
        // Find matching original node for granular cell coloring
        final origNode = treeNodes.firstWhere((n) => '${n.id}' == genericNode.id);
        return _buildMergeNodeCard(context, origNode, genericNode, activeRange);
      },
    );
  }

  Map<String, dynamic> _getActiveRange(SortState state) {
    if (state.currentEventType == SortEventType.split) {
      return {'left': state.activeIndexA, 'right': state.activeIndexB, 'type': 'split'};
    }
    if (state.activeIndexA != -1) {
      return {'activeA': state.activeIndexA, 'activeB': state.activeIndexB, 'type': 'active'};
    }
    return {};
  }

  Widget _buildMergeNodeCard(
    BuildContext context,
    TreeNode node,
    AlgorithmTreeNode genericNode,
    Map<String, dynamic> activeRange,
  ) {
    final rangeLength = node.right - node.left + 1;
    final isEmphasized = genericNode.status == AlgorithmNodeStatus.active ||
        genericNode.status == AlgorithmNodeStatus.highlighted;

    final borderColor = genericNode.customColor ?? Theme.of(context).colorScheme.outline;
    final bgColor = genericNode.customBgColor ?? Theme.of(context).colorScheme.surface;

    bool isNodeSplitActive = genericNode.status == AlgorithmNodeStatus.highlighted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
          width: isEmphasized ? 2.0 : 1.0,
        ),
        boxShadow: isEmphasized
            ? [
                BoxShadow(
                  color: borderColor.withValues(alpha: 0.3),
                  blurRadius: 6,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            genericNode.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isEmphasized
                      ? borderColor
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(rangeLength, (offset) {
              final globalIndex = node.left + offset;
              final val = globalIndex < state.array.length ? state.array[globalIndex] : 0;
              final isItemActiveA = globalIndex == state.activeIndexA;
              final isItemActiveB = globalIndex == state.activeIndexB;
              final isItemSorted = state.sortedIndices.contains(globalIndex);

              Color itemBg = Theme.of(context).colorScheme.surfaceContainerHighest;
              Color itemText = Theme.of(context).colorScheme.onSurfaceVariant;

              if (isItemActiveA || isItemActiveB) {
                if (state.currentEventType == SortEventType.merge && isItemActiveA) {
                  itemBg = Colors.orangeAccent;
                  itemText = Colors.white;
                } else {
                  itemBg = Colors.redAccent;
                  itemText = Colors.white;
                }
              } else if (isItemSorted) {
                itemBg = Colors.green;
                itemText = Colors.white;
              } else if (isNodeSplitActive) {
                final mid = node.left + (node.right - node.left) ~/ 2;
                if (globalIndex <= mid) {
                  itemBg = Colors.purpleAccent;
                  itemText = Colors.white;
                } else {
                  itemBg = Colors.cyan;
                  itemText = Colors.white;
                }
              }

              return Container(
                width: rangeLength > 8 ? 28 : 36,
                height: rangeLength > 8 ? 28 : 36,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: itemBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$val',
                  style: TextStyle(
                    fontSize: rangeLength > 8 ? 11 : 13,
                    fontWeight: FontWeight.bold,
                    color: itemText,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
