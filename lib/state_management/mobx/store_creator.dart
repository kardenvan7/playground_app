import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

class StoreCreator<T extends Store> extends StatefulWidget {
  const StoreCreator({
    required this.create,
    required this.builder,
    super.key,
  });

  final T Function(BuildContext) create;
  final Widget Function(BuildContext, T) builder;

  @override
  State<StoreCreator<T>> createState() => _StoreCreatorState<T>();
}

class _StoreCreatorState<T extends Store> extends State<StoreCreator<T>> {
  late final T _store;

  @override
  void initState() {
    _store = widget.create(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _store);
  }
}
