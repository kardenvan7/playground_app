import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:playground_app/state_management/load_info_use_case.dart';
import 'package:playground_app/state_management/mobx/some_store.dart';
import 'package:playground_app/state_management/mobx/store_creator.dart';
import 'package:playground_app/state_management/some_state.dart';

class MobXWidgetToManage extends StatelessWidget {
  const MobXWidgetToManage({
    required this.loadInfoUseCase,
    super.key,
  });

  final LoadInfoUseCase loadInfoUseCase;

  @override
  Widget build(BuildContext context) {
    return StoreCreator(
      create: (_) => SomeStore(loadInfoUseCase: loadInfoUseCase),
      builder: (context, store) {
        return Scaffold(
          appBar: AppBar(
            title: Observer(
              builder: (context) {
                return Text(
                  switch (store.state) {
                    InitialSomeState() => 'Initial',
                    LoadingSomeState() => 'Loading...',
                    LoadedSomeState() => 'Loaded!',
                    ErrorSomeState() => 'Error :(',
                  },
                );
              },
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Observer(
                      builder: (_) => switch (store.state) {
                        InitialSomeState() => ElevatedButton(
                            onPressed: () => store.loadData(),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
