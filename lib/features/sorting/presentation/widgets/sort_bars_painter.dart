import 'package:flutter/material.dart';

class SortBarsPainter extends CustomPainter {
  final List<int> array;
  final int activeIndexA;
  final int activeIndexB;
  final List<int> sortedIndices;
  final int maxValue;

  const SortBarsPainter({
    required this.array,
    required this.activeIndexA,
    required this.activeIndexB,
    required this.sortedIndices,
    required this.maxValue,
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
        paint.color = Colors.red;
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