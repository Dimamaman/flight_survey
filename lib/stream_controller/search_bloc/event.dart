sealed class SearchEvent {
  const SearchEvent();
}

final class SearchChangedEvent extends SearchEvent {
  final String query;
  final String filter;

  const SearchChangedEvent({required this.query, required this.filter});
}
