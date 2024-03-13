import 'package:flutter/material.dart';
import 'package:playground_app/state_management/load_info_use_case.dart';
import 'package:playground_app/state_management/some_state.dart';

class StatefulWidgetToManage extends StatefulWidget {
  const StatefulWidgetToManage({
    required this.loadInfoUseCase,
    super.key,
  });

  final LoadInfoUseCase loadInfoUseCase;

  @override
  State<StatefulWidgetToManage> createState() => _StatefulWidgetToManageState();
}

class _StatefulWidgetToManageState extends State<StatefulWidgetToManage> {
  SomeState _state = InitialSomeState();

  Future<void> _loadData() async {
    try {
      final data = await widget.loadInfoUseCase();

      setState(() => _state = LoadedSomeState(data));
    } catch (error, stackTrace) {
      setState(() => _state = ErrorSomeState(error, stackTrace));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          switch (_state) {
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
                switch (_state) {
                  InitialSomeState() => ElevatedButton(
                      onPressed: _loadData,
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
