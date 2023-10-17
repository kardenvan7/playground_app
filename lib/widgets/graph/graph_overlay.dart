part of 'graph.dart';

class _GraphOverlay extends StatefulWidget {
  const _GraphOverlay({
    required this.controller,
    required this.child,
    required this.textBuilder,
    required this.hintStyle,
    super.key,
  });

  final GraphOverlayController controller;
  final Widget child;
  final TextStyle? hintStyle;
  final PointOverlayTextBuilder? textBuilder;

  @override
  State<_GraphOverlay> createState() => _GraphOverlayState();
}

class _GraphOverlayState extends State<_GraphOverlay> {
  late final StreamSubscription<GraphOverlayCommand> _sub;
  final GlobalKey<OverlayState> _overlayKey = GlobalKey<OverlayState>();

  final Map<GraphOverlayEntryModel, ({OverlayEntry entry, Timer timer})>
      _modelToEntryTimerMap = {};

  @override
  void initState() {
    _sub =
        widget.controller.overlayEntriesStream.listen(_overlayStreamListener);
    super.initState();
  }

  void _overlayStreamListener(GraphOverlayCommand command) {
    switch (command) {
      case NewEntryGraphOverlayCommand():
        final model = command.entryModel;
        final entry = switch (model) {
          PointGraphOverlayEntryModel(
            position: final position,
            point: final point
          ) =>
            _createCoordinateEntry(position, point),
        };

        _insertOverlayEntry(model, entry);
        break;
      case RemoveLastGraphOverlayEntryModel():
        _removeLastOverlay();
        break;
    }
  }

  void _removeLastOverlay() {
    if (_modelToEntryTimerMap.isEmpty) return;

    final lastOverlayModel = _modelToEntryTimerMap.keys.last;

    _removeOverlay(lastOverlayModel);
  }

  void _removeOverlay(GraphOverlayEntryModel entryModel) {
    final entryAndTimer = _modelToEntryTimerMap[entryModel];

    if (entryAndTimer == null) return;

    entryAndTimer.timer.cancel();
    entryAndTimer.entry
      ..remove()
      ..dispose();

    _modelToEntryTimerMap.remove(entryModel);
  }

  void _insertOverlayEntry(
    GraphOverlayEntryModel model,
    OverlayEntry newEntry,
  ) {
    _overlayKey.currentState?.insert(newEntry);

    late final timer = Timer(
      model.duration,
      () => _removeOverlay(model),
    );

    _modelToEntryTimerMap[model] = (entry: newEntry, timer: timer);
  }

  OverlayEntry _createCoordinateEntry(
    Offset position,
    Offset point,
  ) {
    final ro = _overlayKey.currentContext?.findRenderObject() as RenderBox;
    final pos = ro.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: position.dy + 5,
          left: position.dx,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            color: Colors.yellow,
            child: Text(
              widget.textBuilder?.call(point) ??
                  _GraphOverlayDefaults.defaultOverlayTextBuilder(point),
              style: widget.hintStyle ??
                  _GraphOverlayDefaults.defaultOverlayHintStyle,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        Overlay(key: _overlayKey),
      ],
    );
  }
}

typedef PointOverlayTextBuilder = String Function(Offset point);

class _GraphOverlayDefaults {
  static const TextStyle defaultOverlayHintStyle = TextStyle(
    fontSize: 14,
    color: Colors.black,
  );

  static String defaultOverlayTextBuilder(Offset point) =>
      '${point.dx.toStringAsFixed(1)}, ${point.dy.toStringAsFixed(1)}';
}
