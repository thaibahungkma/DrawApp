import 'dart:ui';

import 'package:flutter/material.dart';

import 'drawing_points.dart';

class DrawingPainter extends CustomPainter {
  List<DrawingPoints> points;
  Color backgroundColor;
  DrawingPainter({required this.points, required this.backgroundColor});


  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), background);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i].points, points[i + 1].points, points[i].paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i].points], points[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}