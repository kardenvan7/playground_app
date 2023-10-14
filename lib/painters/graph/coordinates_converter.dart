import 'package:flutter/material.dart';

/// Class responsible for graph points to canvas coordinates conversion.
///
class CoordinatesConverter {
  CoordinatesConverter({
    required this.canvasSize,
    required List<Offset> graphCoordinates,
  }) {
    _setMinMaxValues(graphCoordinates);
  }

  final Size canvasSize;

  late final double minX;
  late final double maxX;
  late final double minY;
  late final double maxY;

  double get _graphHeight => maxY - minY;
  double get _graphWidth => maxX - minX;

  void _setMinMaxValues(List<Offset> graphCoordinates) {
    double tempMinX = double.infinity;
    double tempMinY = double.infinity;
    double tempMaxX = double.negativeInfinity;
    double tempMaxY = double.negativeInfinity;

    for (final point in graphCoordinates) {
      final pointX = point.dx;
      final pointY = point.dy;

      tempMinX = tempMinX < pointX ? tempMinX : pointX;
      tempMinY = tempMinY < pointY ? tempMinY : pointY;
      tempMaxX = tempMaxX > pointX ? tempMaxX : pointX;
      tempMaxY = tempMaxY > pointY ? tempMaxY : pointY;
    }

    minX = tempMinX;
    minY = tempMinY;
    maxX = tempMaxX;
    maxY = tempMaxY;
  }

  Offset toCanvasPoint(Offset point) {
    return Offset(
      (point.dx - minX) * canvasSize.width / _graphWidth,
      canvasSize.height - (point.dy - minY) * canvasSize.height / _graphHeight,
    );
  }

  Offset toGraphPoint(Offset point) {
    return Offset(
      point.dx * _graphWidth / canvasSize.width + minX,
      (canvasSize.height - point.dy) * _graphHeight / canvasSize.height + minY,
    );
  }
}
