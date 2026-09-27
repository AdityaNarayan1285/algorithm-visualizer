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

      Color barColor;

      if (currentEventType == SortEventType.split &&
          activeIndexA != -1 &&
          activeIndexB != -1 &&
          i >= activeIndexA &&
          i <= activeIndexB) {
        final mid = activeIndexA + (activeIndexB - activeIndexA) ~/ 2;
        if (i <= mid) {
          barColor = Colors.purpleAccent;
        } else {
          barColor = Colors.cyan;
        }
      } else if (currentEventType == SortEventType.merge &&
          i == activeIndexA) {
        barColor = Colors.orangeAccent;
      } else if (isActive) {
        if (currentEventType == SortEventType.insert &&
            i == activeIndexA) {
          barColor = Colors.amber;
        } else {
          barColor = Colors.red;
        }
      } else if (isSorted) {
        barColor = Colors.green;
      } else {
        barColor = Colors.blue;
      }

      paint.color = barColor;

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