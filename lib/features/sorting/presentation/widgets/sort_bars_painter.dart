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