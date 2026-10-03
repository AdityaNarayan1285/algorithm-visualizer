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

    return LayoutBuilder(
      builder: (context, constraints) {
        final deepestLevelSlots = 1 << maxDepth;
        final treeWidth = (deepestLevelSlots * 54.0).clamp(
          constraints.maxWidth,
          double.infinity,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: treeWidth,
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

                  // Render levels with branching parent-to-daughter arrows
                  for (int depth = 0; depth <= maxDepth; depth++) ...[
                    _buildLevelRow(context, levels[depth], depth),
                    if (depth < maxDepth && levels[depth + 1].isNotEmpty)
                      SizedBox(
                        height: 28,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: _TreeBranchPainter(
                            parentSlots: 1 << depth,
                            parentNodes: levels[depth],
                            childNodes: levels[depth + 1],
                            lineColor: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.4),
                            activeLineColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLevelRow(
    BuildContext context,
    List<AlgorithmTreeNode> nodesAtLevel,
    int depth,
  ) {
    final slotCount = 1 << depth;

    return Row(
      children: List.generate(slotCount, (slotIndex) {
        if (slotIndex < nodesAtLevel.length) {
          final node = nodesAtLevel[slotIndex];
          return Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: customNodeBuilder != null
                    ? customNodeBuilder!(context, node)
                    : _buildDefaultNodeCard(context, node),
              ),
            ),
          );
        } else {
          return const Expanded(
            child: SizedBox.shrink(),
          );
        }
      }),
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

/// Custom painter that draws branching connector lines and downward arrows
/// from each parent node to its daughter (left and right) child nodes.
class _TreeBranchPainter extends CustomPainter {
  final int parentSlots;
  final List<AlgorithmTreeNode> parentNodes;
  final List<AlgorithmTreeNode> childNodes;
  final Color lineColor;
  final Color activeLineColor;

  _TreeBranchPainter({
    required this.parentSlots,
    required this.parentNodes,
    required this.childNodes,
    required this.lineColor,
    required this.activeLineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final parentWidth = size.width / parentSlots;
    final childSlots = parentSlots * 2;
    final childWidth = size.width / childSlots;

    for (int p = 0; p < parentSlots; p++) {
      if (p >= parentNodes.length) continue;
      final parentNode = parentNodes[p];

      final px = (p + 0.5) * parentWidth;
      const py = 0.0;

      // 1. Left daughter node (slot = 2 * p)
      final leftSlot = 2 * p;
      if (leftSlot < childNodes.length) {
        final leftChild = childNodes[leftSlot];
        final cx = (leftSlot + 0.5) * childWidth;
        final cy = size.height;
        _drawBranch(canvas, Offset(px, py), Offset(cx, cy), parentNode, leftChild);
      }

      // 2. Right daughter node (slot = 2 * p + 1)
      final rightSlot = 2 * p + 1;
      if (rightSlot < childNodes.length) {
        final rightChild = childNodes[rightSlot];
        final cx = (rightSlot + 0.5) * childWidth;
        final cy = size.height;
        _drawBranch(canvas, Offset(px, py), Offset(cx, cy), parentNode, rightChild);
      }
    }
  }

  void _drawBranch(
    Canvas canvas,
    Offset start,
    Offset end,
    AlgorithmTreeNode parent,
    AlgorithmTreeNode child,
  ) {
    final isParentActive = parent.status == AlgorithmNodeStatus.active ||
        parent.status == AlgorithmNodeStatus.highlighted;
    final isChildActive = child.status == AlgorithmNodeStatus.active ||
        child.status == AlgorithmNodeStatus.highlighted;
    final isActiveBranch = isParentActive && isChildActive;

    Color strokeColor = lineColor;
    double strokeWidth = 1.2;

    if (isActiveBranch) {
      strokeColor = child.customColor ?? parent.customColor ?? activeLineColor;
      strokeWidth = 2.2;
    } else if (child.status == AlgorithmNodeStatus.completed &&
        parent.status == AlgorithmNodeStatus.completed) {
      strokeColor = Colors.green.withValues(alpha: 0.45);
    }

    // Draw smooth branch curve
    final linePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(start.dx, start.dy);
    path.cubicTo(
      start.dx,
      start.dy + (end.dy - start.dy) * 0.55,
      end.dx,
      end.dy - (end.dy - start.dy) * 0.45,
      end.dx,
      end.dy - 3.0,
    );
    canvas.drawPath(path, linePaint);

    // Draw downward arrow pointing to child node
    final arrowPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;

    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(end.dx - 3.5, end.dy - 5.5)
      ..lineTo(end.dx + 3.5, end.dy - 5.5)
      ..close();

    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant _TreeBranchPainter oldDelegate) {
    return true;
  }
}

