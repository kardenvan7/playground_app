import 'dart:async';

import 'package:flutter/material.dart';
import 'package:playground_app/painters/graph/graph_painter.dart';

class Graph extends StatefulWidget {
  const Graph({
    required this.points,
    this.drawAxes = false,
    this.graphPaint,
    this.axesPaint,
    this.graphPointStyle,
    this.tappedPointStyle,
    this.overlayHintStyle,
    this.overlayTextBuilder,
    this.overlayDuration = const Duration(seconds: 2),
    super.key,
  });

  final List<Offset> points;
  final bool drawAxes;
  final Paint? graphPaint;
  final Paint? axesPaint;
  final GraphPointStyle? graphPointStyle;
  final GraphPointStyle? tappedPointStyle;
  final TextStyle? overlayHintStyle;
  final PointOverlayTextBuilder? overlayTextBuilder;
  final Duration overlayDuration;

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  static final GraphPointStyle _defaultGraphPointStyle = GraphPointStyle(
    paint: Paint()
      ..color = Colors.black
      ..strokeWidth = .5
      ..style = PaintingStyle.fill,
    radius: 2,
  );

  static final GraphPointStyle _defaultTappedPointStyle = GraphPointStyle(
    paint: Paint()
      ..color = Colors.blue
      ..strokeWidth = 1
      ..style = PaintingStyle.fill,
    radius: 2,
  );

  static final Paint _defaultGraphPaint = Paint()
    ..color = Colors.green
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  static final Paint _defaultAxesPaint = Paint()
    ..color = Colors.grey.withOpacity(.7)
    ..strokeWidth = .5
    ..style = PaintingStyle.stroke;

  static const TextStyle _defaultOverlayHintStyle = TextStyle(
    fontSize: 14,
    color: Colors.black,
  );

  static String _defaultOverlayTextBuilder(Offset point) => 'Point $point';

  final GlobalKey<OverlayState> _overlayKey = GlobalKey();
  Offset? _pickedPoint;
  Timer? _overlayTimer;
  OverlayEntry? _overlayEntry;

  void _removeCurrentOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _overlayTimer?.cancel();
    _overlayTimer = null;
  }

  void _onTap(BuildContext context, Offset position, Offset graphPoint) {
    _removeCurrentOverlay();

    final newEntry = _createCoordinateEntry(context, position, graphPoint);

    _insertNewOverlay(newEntry);

    setState(() {
      _pickedPoint = position;
    });
  }

  void _insertNewOverlay(OverlayEntry newEntry) {
    _overlayKey.currentState?.insert(newEntry);

    _overlayEntry = newEntry;

    _overlayTimer = Timer(
      widget.overlayDuration,
      () {
        final isMounted = _overlayEntry?.mounted ?? false;

        if (isMounted) {
          _overlayEntry?.remove();
          _overlayEntry = null;
        }
      },
    );
  }

  OverlayEntry _createCoordinateEntry(
    BuildContext context,
    Offset position,
    Offset point,
  ) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + 5,
        left: position.dx,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          color: Colors.yellow,
          child: Text(
            widget.overlayTextBuilder?.call(point) ??
                _defaultOverlayTextBuilder(point),
            style: widget.overlayHintStyle ?? _defaultOverlayHintStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: GraphPainter(
              onTap: (pos, point) => _onTap(context, pos, point),
              graphPoints: widget.points,
              drawAxes: widget.drawAxes,
              tappedPoint: _pickedPoint,
              graphPaint: widget.graphPaint ?? _defaultGraphPaint,
              axesPaint: widget.axesPaint ?? _defaultAxesPaint,
              graphPointPaint:
                  widget.graphPointStyle ?? _defaultGraphPointStyle,
              tappedPointPaint:
                  widget.tappedPointStyle ?? _defaultTappedPointStyle,
            ),
          ),
        ),
        Overlay(
          key: _overlayKey,
        ),
      ],
    );
  }
}

typedef PointOverlayTextBuilder = String Function(Offset point);
