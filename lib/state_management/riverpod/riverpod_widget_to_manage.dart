import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playground_app/state_management/load_info_use_case.dart';
import 'package:playground_app/state_management/some_state.dart';

final someStateProvider = StateProvider<SomeState>((_) => InitialSomeState());

class RiverpodWidgetToManage extends ConsumerWidget {
  const RiverpodWidgetToManage({
    required this.loadInfoUseCase,
    super.key,
  });

  final LoadInfoUseCase loadInfoUseCase;

  Future<void> _onButtonPressed(
    BuildContext context,
    StateController<SomeState> stateController,
  ) async {
    stateController.state = LoadingSomeState();

    try {
      final data = await loadInfoUseCase();

      stateController.state = LoadedSomeState(data);
    } catch (e, st) {
      stateController.state = ErrorSomeState(e, st);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateController = ref.watch(someStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          switch (stateController.state) {
            InitialSomeState() => 'Initial',
            LoadingSomeState() => 'Loading...',
            LoadedSomeState() => 'Loaded!',
            ErrorSomeState() => 'Error :(',
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                switch (stateController.state) {
                  InitialSomeState() => ElevatedButton(
                      onPressed: () =>
                          _onButtonPressed(context, stateController),
                      child: const Text('Load data'),
                    ),
                  LoadingSomeState() => const SizedBox(
                      height: 80,
                      width: 80,
                      child: CircularProgressIndicator(),
                    ),
                  LoadedSomeState(data: final dataList) => Column(
                      children: dataList
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(e),
                            ),
                          )
                          .toList(),
                    ),
                  ErrorSomeState(
                    error: final error,
                    stackTrace: final trace,
                  ) =>
                    Column(
                      children: [
                        Text(error.toString()),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(trace.toString()),
                        ),
                      ],
                    ),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }
}
