import 'package:flutter/material.dart';

/// Class responsible for graph points to canvas coordinates conversion.
///
class CoordinatesConverter {
  CoordinatesConverter({
    required this.canvasSize,
    required ({Offset bottomLeft, Offset topRight}) graphCorners,
  }) {
    _setMinMaxValues(graphCorners);
  }

  final Size canvasSize;

  late final double minX;
  late final double maxX;
  late final double minY;
  late final double maxY;

  double get _graphHeight => maxY - minY;
  double get _graphWidth => maxX - minX;

  void _setMinMaxValues(({Offset bottomLeft, Offset topRight}) graphCorners) {
    minX = graphCorners.bottomLeft.dx;
    minY = graphCorners.bottomLeft.dy;
    maxX = graphCorners.topRight.dx;
    maxY = graphCorners.topRight.dy;
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
