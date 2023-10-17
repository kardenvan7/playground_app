import 'dart:async';

import 'package:flutter/material.dart';
import 'package:playground_app/painters/graph/graph_painter.dart';

part 'graph_overlay.dart';
part 'graph_overlay_controller.dart';
part 'graph_overlay_entry_model.dart';

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
    this.topRight,
    this.bottomLeft,
    super.key,
  });

  final List<Offset> points;
  final Offset? bottomLeft;
  final Offset? topRight;
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
  late final GraphOverlayController _overlayController;

  Offset? _pickedPoint;
  Timer? _pickedPointTimer;

  @override
  void initState() {
    _overlayController = DefaultGraphOverlayController();
    super.initState();
  }

  void _onTap(Offset position, Offset graphPoint) {
    _pickedPointTimer?.cancel();
    _overlayController.removeLastEntry();
    _overlayController.showCoordinateOverlay(
      position: position,
      graphPoint: graphPoint,
      duration: widget.overlayDuration,
    );

    setState(() {
      _pickedPoint = position;
      _pickedPointTimer = Timer.periodic(
        widget.overlayDuration,
        (timer) {
          setState(() {
            _pickedPoint = null;
            _pickedPointTimer?.cancel();
            _pickedPointTimer = null;
          });
        },
      );
    });
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GraphOverlay(
      controller: _overlayController,
      textBuilder: widget.overlayTextBuilder,
      hintStyle: widget.overlayHintStyle,
      child: ClipRect(
        child: CustomPaint(
          painter: GraphPainter(
            onTap: _onTap,
            bottomLeftPoint: widget.bottomLeft,
            topRightPoint: widget.topRight,
            graphPoints: widget.points,
            drawAxes: widget.drawAxes,
            tappedPoint: _pickedPoint,
            graphPaint: widget.graphPaint ?? _GraphDefaults.defaultGraphPaint,
            axesPaint: widget.axesPaint ?? _GraphDefaults.defaultAxesPaint,
            graphPointPaint:
                widget.graphPointStyle ?? _GraphDefaults.defaultGraphPointStyle,
            tappedPointPaint: widget.tappedPointStyle ??
                _GraphDefaults.defaultTappedPointStyle,
          ),
        ),
      ),
    );
  }
}

class _GraphDefaults {
  static final GraphPointStyle defaultGraphPointStyle = GraphPointStyle(
    paint: Paint()
      ..color = Colors.black
      ..strokeWidth = .5
      ..style = PaintingStyle.fill,
    radius: 2,
  );

  static final GraphPointStyle defaultTappedPointStyle = GraphPointStyle(
    paint: Paint()
      ..color = Colors.blue
      ..strokeWidth = 1
      ..style = PaintingStyle.fill,
    radius: 2,
  );

  static final Paint defaultGraphPaint = Paint()
    ..color = Colors.green
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  static final Paint defaultAxesPaint = Paint()
    ..color = Colors.grey.withOpacity(.7)
    ..strokeWidth = .5
    ..style = PaintingStyle.stroke;
}
