part of 'graph.dart';

sealed class GraphOverlayEntryModel {}

final class PointGraphOverlayEntryModel implements GraphOverlayEntryModel {
  const PointGraphOverlayEntryModel({
    required this.position,
    required this.point,
  });

  final Offset position;
  final Offset point;

  @override
  int get hashCode => Object.hash(position, point);

  @override
  bool operator ==(Object other) {
    if (other is! PointGraphOverlayEntryModel) return false;

    return position == other.position && point == other.point;
  }
}
