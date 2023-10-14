import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:playground_app/painters/graph/coordinates_converter.dart';

class GraphPainter extends CustomPainter {
  GraphPainter({
    required this.graphPoints,
    required this.tappedPoint,
    required this.onTap,
    required this.drawAxes,
    required this.graphPaint,
    required this.axesPaint,
    required this.graphPointPaint,
    required this.tappedPointPaint,
  }) : assert(graphPoints.length > 2);

  final List<Offset> graphPoints;
  final Offset? tappedPoint;
  final void Function(Offset canvasPosition, Offset graphPoint)? onTap;
  final bool drawAxes;
  final Paint graphPaint;
  final Paint axesPaint;
  final GraphPointStyle tappedPointPaint;
  final GraphPointStyle graphPointPaint;

  late CoordinatesConverter _converter;
  late Map<Offset, Offset> _graphPointToCanvasPointMap;

  @override
  void paint(Canvas canvas, Size size) {
    _setConverter(size);
    _mapGraphCoordsToCanvasCoords();

    _drawAxes(canvas);
    _drawGraph(canvas);
    _drawTappedPoint(canvas);
  }

  void _setConverter(Size canvasSize) {
    _converter = CoordinatesConverter(
      canvasSize: canvasSize,
      graphCoordinates: graphPoints,
    );
  }

  void _mapGraphCoordsToCanvasCoords() {
    _graphPointToCanvasPointMap = {
      for (final point in graphPoints) point: _converter.toCanvasPoint(point)
    };
  }

  void _drawTappedPoint(Canvas canvas) {
    final point = tappedPoint;

    if (point == null) return;

    canvas.drawCircle(point, tappedPointPaint.radius, tappedPointPaint.paint);
  }

  void _drawAxes(Canvas canvas) {
    if (!drawAxes) return;

    _drawVerticalAxes(canvas);
    _drawHorizontalAxes(canvas);
  }

  void _drawHorizontalAxes(Canvas canvas) {
    for (int i = _converter.minY.ceil(); i < _converter.maxY; i++) {
      final iDouble = i.toDouble();

      canvas.drawLine(
        _converter.toCanvasPoint(Offset(_converter.minX, iDouble)),
        _converter.toCanvasPoint(Offset(_converter.maxX, iDouble)),
        axesPaint,
      );
    }
  }

  void _drawVerticalAxes(Canvas canvas) {
    for (int i = _converter.minX.ceil(); i < _converter.maxX; i++) {
      final iDouble = i.toDouble();

      canvas.drawLine(
        _converter.toCanvasPoint(Offset(iDouble, _converter.minY)),
        _converter.toCanvasPoint(Offset(iDouble, _converter.maxY)),
        axesPaint,
      );
    }
  }

  void _drawGraph(Canvas canvas) {
    final path = Path();
    final firstPoint = graphPoints.first;
    final convertedFirstPoint = _graphPointToCanvasPointMap[firstPoint]!;

    path.moveTo(convertedFirstPoint.dx, convertedFirstPoint.dy);
    canvas.drawCircle(
        convertedFirstPoint, tappedPointPaint.radius, graphPointPaint.paint);

    for (int i = 1; i < graphPoints.length; i++) {
      final convertedPoint = _graphPointToCanvasPointMap[graphPoints[i]]!;
      path.lineTo(convertedPoint.dx, convertedPoint.dy);
      canvas.drawCircle(
          convertedPoint, tappedPointPaint.radius, graphPointPaint.paint);
    }

    canvas.drawPath(path, graphPaint);
  }

  @override
  bool? hitTest(Offset position) {
    onTap?.call(position, _converter.toGraphPoint(position));
    return true;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! GraphPainter ||
        onTap != oldDelegate.onTap ||
        tappedPoint != oldDelegate.tappedPoint ||
        listEquals(graphPoints, oldDelegate.graphPoints);
  }
}

class GraphPointStyle {
  const GraphPointStyle({
    required this.paint,
    required this.radius,
  });

  final Paint paint;
  final double radius;
}
