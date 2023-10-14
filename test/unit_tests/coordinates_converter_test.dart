import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground_app/painters/graph/coordinates_converter.dart';

void main() {
  late Size mockSize;
  late List<Offset> mockPoints;

  CoordinatesConverter getUut() => CoordinatesConverter(
        canvasSize: mockSize,
        graphCoordinates: mockPoints,
      );

  group(
    'CoordinatesConverter',
    () {
      test(
        'Correctly converts to canvas coordinate',
        () {
          mockSize = const Size(300, 200);
          mockPoints = const <Offset>[
            Offset(-11, -5),
            Offset(19, 15),
          ];

          const validPair = (
            graph: Offset(0, 0),
            canvas: Offset(110, 150),
          );

          final uut = getUut();

          final canvasCoord = uut.toCanvasPoint(validPair.graph);

          expect(canvasCoord, validPair.canvas);
        },
      );

      test(
        'Correctly converts to graph coordinate',
        () {
          mockSize = const Size(300, 200);
          mockPoints = const <Offset>[
            Offset(-11, -5),
            Offset(19, 15),
          ];

          final uut = getUut();

          const validPair = (
            graph: Offset(0, 0),
            canvas: Offset(110, 150),
          );

          final graphCoord = uut.toGraphPoint(validPair.canvas);

          expect(graphCoord, validPair.graph);
        },
      );
    },
  );
}
