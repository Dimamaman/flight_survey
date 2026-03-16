sealed class SearchState {
  final List<String> results;

  bool get isLoading => switch (this) {
    SearchLoadingState() => true,
    _ => false,
  };

  const SearchState(this.results);
}

final class SearchIdleState extends SearchState {
  const SearchIdleState(super.results);
}

final class SearchLoadingState extends SearchState {
  const SearchLoadingState(super.results);
}

final class SearchSuccessState extends SearchState {
  const SearchSuccessState(super.results);
}

final class SearchErrorState extends SearchState {
  const SearchErrorState(super.results);
}
