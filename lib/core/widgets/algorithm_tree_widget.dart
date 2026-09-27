import 'package:flutter/material.dart';

/// Status of a node in an algorithm tree / flowchart.
enum AlgorithmNodeStatus {
  idle,
  active,
  highlighted,
  completed,
  custom,
}

/// Generic tree node for algorithm visualizations (Sorting, Pathfinding, Trees, DP).
class AlgorithmTreeNode {
  final String id;
  final String label;
  final int depth;
  final String? parentId;
  final List<dynamic> items;
  final AlgorithmNodeStatus status;
  final Color? customColor;
  final Color? customBgColor;

  const AlgorithmTreeNode({
    required this.id,
    required this.label,
    required this.depth,
    this.parentId,
    this.items = const [],
    this.status = AlgorithmNodeStatus.idle,
    this.customColor,
    this.customBgColor,
  });
}

/// A generic, reusable tree/flowchart visualization widget.
/// Works across Sorting (Merge/Quick sort trees), Pathfinding (Dijkstra/BFS search trees),
/// and Tree/Graph data structures.
class AlgorithmTreeWidget extends StatelessWidget {
  final List<AlgorithmTreeNode> nodes;
  final String? statusTitle;
  final IconData statusIcon;
  final Widget Function(BuildContext context, AlgorithmTreeNode node)? customNodeBuilder;

  const AlgorithmTreeWidget({
    super.key,
    required this.nodes,
    this.statusTitle,
    this.statusIcon = Icons.account_tree_outlined,
    this.customNodeBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return const Center(child: Text('No tree data available'));
    }

    // Group nodes by level (depth)
    final maxDepth = nodes.fold<int>(0, (max, n) => n.depth > max ? n.depth : max);
    final levels = List<List<AlgorithmTreeNode>>.generate(maxDepth + 1, (_) => []);
    for (final node in nodes) {
      if (node.depth >= 0 && node.depth <= maxDepth) {
        levels[node.depth].add(node);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          // Optional Header Banner
          if (statusTitle != null && statusTitle!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    statusIcon,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      statusTitle!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),

          // Render levels vertically
          for (int depth = 0; depth <= maxDepth; depth++) ...[
            _buildLevelRow(context, levels[depth], maxDepth),
            if (depth < maxDepth)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(
                  Icons.south,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildLevelRow(
    BuildContext context,
    List<AlgorithmTreeNode> nodesAtLevel,
    int maxDepth,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: nodesAtLevel.map((node) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: customNodeBuilder != null
                      ? customNodeBuilder!(context, node)
                      : _buildDefaultNodeCard(context, node),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultNodeCard(BuildContext context, AlgorithmTreeNode node) {
    Color borderColor = node.customColor ?? Theme.of(context).colorScheme.outline;
    Color bgColor = node.customBgColor ?? Theme.of(context).colorScheme.surface;

    if (node.customColor == null) {
      switch (node.status) {
        case AlgorithmNodeStatus.active:
          borderColor = Colors.redAccent;
          bgColor = Colors.redAccent.withValues(alpha: 0.12);
          break;
        case AlgorithmNodeStatus.highlighted:
          borderColor = Colors.purpleAccent;
          bgColor = Colors.purpleAccent.withValues(alpha: 0.15);
          break;
        case AlgorithmNodeStatus.completed:
          borderColor = Colors.green;
          bgColor = Colors.green.withValues(alpha: 0.08);
          break;
        case AlgorithmNodeStatus.idle:
        case AlgorithmNodeStatus.custom:
          break;
      }
    }

    final isEmphasized = node.status == AlgorithmNodeStatus.active ||
        node.status == AlgorithmNodeStatus.highlighted;

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
          // Node Label
          Text(
            node.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isEmphasized
                      ? borderColor
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          if (node.items.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: node.items.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$item',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
