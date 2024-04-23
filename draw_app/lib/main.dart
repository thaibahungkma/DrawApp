import 'package:flutter/material.dart';

import 'model/drawing_painter.dart';
import 'model/drawing_points.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawingPage(),
    );
  }
}

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<DrawingPoints> points = [];
  Color selectedColor = Colors.black;
  Color backgroundColor = Colors.white;
  double strokeWidth = 4.0;
  bool isEraserMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.color_lens, color: selectedColor),
            onPressed: () {
              pickColor(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.circle, size: isEraserMode ? 30.0 : 20.0, color: isEraserMode ? backgroundColor : backgroundColor.withOpacity(0.9) ),
            onPressed: () {
              toggleEraser();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteAll();
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Logic to save the painting
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Builder(builder: (context) =>
              GestureDetector(
                onPanUpdate: (details) {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  Offset localPosition = renderBox.globalToLocal(details.globalPosition);
                  localPosition = Offset(localPosition.dx, localPosition.dy);
                  addPoint(localPosition);
                },
                onPanEnd: (details) {
                  points.add(DrawingPoints(points: Offset.infinite, paint: Paint()));
                },
                child: RepaintBoundary(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: DrawingPainter(points: points, backgroundColor: backgroundColor),
                  ),
                ),
              ),),
          Positioned(
            bottom: 1,
            left: 1,
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: strokeWidth,
                min: 1.0,
                max: 30.0,
                thumbColor: selectedColor,
                onChanged: (double value) {
                  setState(() {
                    strokeWidth = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addPoint(Offset localPosition) {
    Paint paint = Paint()
      ..color = isEraserMode ? backgroundColor :selectedColor
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..blendMode = isEraserMode ? BlendMode.src : BlendMode.srcOver;
    setState(() {
      points.add(DrawingPoints(points: localPosition, paint: paint, isErasing: isEraserMode));
    });
  }


  void pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            FloatingActionButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void deleteAll() {
    setState(() {
      points.clear();
    });
  }
  void toggleEraser() {
    setState(() {
      isEraserMode = !isEraserMode;
      strokeWidth = isEraserMode ? 20.0 : 4.0;
    });
  }
}
