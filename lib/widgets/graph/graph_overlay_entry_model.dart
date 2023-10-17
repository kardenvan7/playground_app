part of 'graph.dart';

sealed class GraphOverlayEntryModel {
  Duration get duration;
}

final class PointGraphOverlayEntryModel implements GraphOverlayEntryModel {
  const PointGraphOverlayEntryModel({
    required this.position,
    required this.point,
    required this.duration,
  });

  final Offset position;
  final Offset point;
  @override
  final Duration duration;

  @override
  int get hashCode => Object.hash(position, point, duration);

  @override
  bool operator ==(Object other) {
    if (other is! PointGraphOverlayEntryModel) return false;

    return position == other.position &&
        point == other.point &&
        duration == other.duration;
  }
}
