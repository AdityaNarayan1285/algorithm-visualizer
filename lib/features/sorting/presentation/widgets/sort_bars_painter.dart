import 'package:flutter/material.dart';

class SortBarsPainter extends CustomPainter {
  final List<int> array;
  final int activeIndexA;
  final int activeIndexB;
  final int maxValue;

  const SortBarsPainter({
    required this.array,
    required this.activeIndexA,
    required this.activeIndexB,
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

      // Highlight active bars.
      if (i == activeIndexA || i == activeIndexB) {
        paint.color = Colors.red;
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