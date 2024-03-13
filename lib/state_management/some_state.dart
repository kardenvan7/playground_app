sealed class SomeState {}

final class InitialSomeState implements SomeState {}

final class LoadingSomeState implements SomeState {}

final class LoadedSomeState implements SomeState {
  const LoadedSomeState(this.data);

  final List<String> data;
}

final class ErrorSomeState implements SomeState {
  const ErrorSomeState(this.error, [this.stackTrace]);

  final Object? error;
  final StackTrace? stackTrace;
}
