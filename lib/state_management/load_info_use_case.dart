class LoadInfoUseCase {
  Future<List<String>> call() {
    return Future.delayed(
      const Duration(seconds: 1),
      () => <String>[
        'Wow!',
        'So cool!',
        'This info is amazing!',
      ],
    );
  }
}
