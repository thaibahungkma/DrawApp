import 'dart:ui';

class DrawingPoints {
  Paint paint;
  Offset points;
  bool isErasing;
  DrawingPoints({required this.points, required this.paint, this.isErasing = false});
}