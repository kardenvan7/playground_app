import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground_app/state_management/load_info_use_case.dart';
import 'package:playground_app/state_management/some_state.dart';

part 'some_bloc.dart';

class BlocWidgetToManage extends StatelessWidget {
  const BlocWidgetToManage({
    required this.loadInfoUseCase,
    super.key,
  });

  final LoadInfoUseCase loadInfoUseCase;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _SomeBloc(loadInfoUseCase: loadInfoUseCase),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<_SomeBloc, SomeState>(
            builder: (context, state) {
              return Text(
                switch (state) {
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
              child: BlocBuilder<_SomeBloc, SomeState>(
                builder: (context, state) {
                  final bloc = context.read<_SomeBloc>();

                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      switch (state) {
                        InitialSomeState() => ElevatedButton(
                            onPressed: () => bloc.add(_LoadSomeEvent()),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
