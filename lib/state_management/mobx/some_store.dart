import 'package:mobx/mobx.dart';
import 'package:playground_app/state_management/load_info_use_case.dart';
import 'package:playground_app/state_management/some_state.dart';

part 'some_store.g.dart';

class SomeStore = SomeStoreBase with _$SomeStore;

abstract class SomeStoreBase with Store {
  SomeStoreBase({
    required LoadInfoUseCase loadInfoUseCase,
  }) : _loadInfoUseCase = loadInfoUseCase;

  final LoadInfoUseCase _loadInfoUseCase;

  @readonly
  SomeState _state = InitialSomeState();

  @action
  Future<void> loadData() async {
    _state = LoadingSomeState();

    try {
      final data = await _loadInfoUseCase();

      _state = LoadedSomeState(data);
    } catch (e, st) {
      _state = ErrorSomeState(e, st);
    }
  }
}
