import 'dart:async';

import 'package:rxdart/rxdart.dart';

final class SearchBLoC {
  final StreamController<String> _searchController =
      StreamController<String>.broadcast();

  final StreamController<String> _filterController =
      StreamController<String>.broadcast();

  final StreamController<List<String>> _resultsController =
      StreamController<List<String>>.broadcast();

  final StreamController<bool> _isLoadingController =
      StreamController<bool>.broadcast();

  List<String> _results = <String>[];
  bool _isLoading = false;

  late final StreamSubscription<void> _combinedSubscription;

  SearchBLoC() {
    _initialize();
  }

  List<String> get results => _results;
  bool get isLoading => _isLoading;

  Stream<List<String>> get resultsStream => _resultsController.stream;
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  StreamSink<String> get filterSink => _filterController.sink;
  StreamSink<String> get searchSink => _searchController.sink;

  void _initialize() {
    // _combinedSubscription =
    //     CombineLatestStream.combine2<
    //           String,
    //           String,
    //           ({String query, String filter})
    //         >(
    //           _searchController.stream,
    //           _filterController.stream,
    //           (query, filter) => (query: query, filter: filter),
    //         )
    //         .asyncMap((params) {
    //           log("JJJJJJJJJJJ ${params.query}");
    //           return _onSearch(params.query, params.filter);
    //         })
    //         .listen(_resultsController.add);
    final Stream<List<String>> stream =
        CombineLatestStream.combine2<
              String,
              String,
              ({String query, String filter})
            >(
              _searchController.stream,
              _filterController.stream,
              (query, filter) => (query: query, filter: filter),
            )
            .asyncMap((params) => _onSearch(params.query, params.filter));

    _combinedSubscription = stream.listen((List<String> result) {
      _resultsController.add(result);
    });
  }

  Future<List<String>> _onSearch(String query, String filter) async {
    _isLoading = true;
    _isLoadingController.add(_isLoading);

    final data = await _fetchData(query, filter);
    _results = data;

    _isLoading = false;
    _isLoadingController.add(_isLoading);

    return data;
  }

  Future<List<String>> _fetchData(String query, String filter) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final allData = <String>[
      'Flutter',
      'Dart',
      'BLoC',
      'Provider',
      'GetX',
      'Riverpod',
      'Clean Architecture',
    ];

    return allData
        .where(
          (item) =>
              item.toLowerCase().contains(query.toLowerCase()) &&
              item.toLowerCase().contains(filter.toLowerCase()),
        )
        .toList();
  }

  Future<void> close() async {
    await [
      _combinedSubscription.cancel(),
      _searchController.close(),
      _filterController.close(),
      _resultsController.close(),
      _isLoadingController.close(),
    ].wait;
  }
}
