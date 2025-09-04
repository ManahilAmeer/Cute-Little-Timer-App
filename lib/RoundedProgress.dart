import 'dart:async';
import 'package:flutter/material.dart';

class RoundedProgress extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final double size;
  final double strokeWidth;

  const RoundedProgress({
    Key? key,
    required this.progress,
    this.size = 180,
    this.strokeWidth = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _RoundedProgressPainter(progress, strokeWidth),
    );
  }
}

class _RoundedProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  _RoundedProgressPainter(this.progress, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bg = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint fg = Paint()
      ..shader = SweepGradient(
        colors: [Colors.orange, Colors.orange.shade400, Colors.yellowAccent],
      ).createShader(Rect.fromCircle(center: size.center(Offset.zero), radius: size.width/2))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // Background circle
    canvas.drawCircle(center, radius, bg);

    // Foreground arc
    final sweep = 2 * 3.1416 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.1416 / 2,
      sweep,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RoundedProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
