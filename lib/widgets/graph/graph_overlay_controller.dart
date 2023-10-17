part of 'graph.dart';

abstract interface class GraphOverlayController {
  void removeLastEntry();

  void showCoordinateOverlay({
    required Offset position,
    required Offset graphPoint,
    Duration duration = const Duration(seconds: 2),
  });

  Stream<GraphOverlayCommand> get overlayEntriesStream;

  Future<void> dispose();
}

final class DefaultGraphOverlayController implements GraphOverlayController {
  DefaultGraphOverlayController();

  final StreamController<GraphOverlayCommand> _streamController =
      StreamController<GraphOverlayCommand>();

  @override
  Stream<GraphOverlayCommand> get overlayEntriesStream =>
      _streamController.stream;

  @override
  void showCoordinateOverlay({
    required Offset position,
    required Offset graphPoint,
    Duration duration = const Duration(seconds: 2),
  }) {
    final entry = _createCoordinateEntryModel(position, graphPoint, duration);

    _streamController.add(entry);
  }

  GraphOverlayCommand _createCoordinateEntryModel(
    Offset position,
    Offset point,
    Duration duration,
  ) {
    return NewEntryGraphOverlayCommand(
      PointGraphOverlayEntryModel(
        position: position,
        point: point,
        duration: duration,
      ),
    );
  }

  @override
  Future<void> dispose() {
    return _streamController.close();
  }

  @override
  void removeLastEntry() {
    _streamController.add(RemoveLastGraphOverlayEntryModel());
  }
}

sealed class GraphOverlayCommand {}

final class NewEntryGraphOverlayCommand implements GraphOverlayCommand {
  const NewEntryGraphOverlayCommand(this.entryModel);

  final GraphOverlayEntryModel entryModel;

  @override
  int get hashCode => entryModel.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! NewEntryGraphOverlayCommand) return false;

    return entryModel == other.entryModel;
  }
}

final class RemoveLastGraphOverlayEntryModel implements GraphOverlayCommand {}
