part of 'bloc_widget_to_manage.dart';

class _SomeBloc extends Bloc<_SomeEvent, SomeState> {
  _SomeBloc({
    required LoadInfoUseCase loadInfoUseCase,
  })  : _loadInfoUseCase = loadInfoUseCase,
        super(InitialSomeState()) {
    on<_SomeEvent>(
      (event, state) => switch (event) {
        _LoadSomeEvent() => _onLoadEvent(event, state),
      },
    );
  }

  final LoadInfoUseCase _loadInfoUseCase;

  Future<void> _onLoadEvent(_LoadSomeEvent _, Emitter emit) async {
    emit(LoadingSomeState());

    try {
      final data = await _loadInfoUseCase();

      emit(LoadedSomeState(data));
    } catch (e, st) {
      emit(ErrorSomeState(e, st));
    }
  }
}

sealed class _SomeEvent {}

final class _LoadSomeEvent implements _SomeEvent {}
