import 'dart:async';

import 'package:flight_survey/stream_controller/search_bloc/event.dart';
import 'package:flight_survey/stream_controller/search_bloc/state.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  late SearchState _state;

  late final StreamSubscription<void> _onEventSubscription;

  // Контроллеры для событий и состояний
  final StreamController<SearchState> _stateController =
      StreamController<SearchState>.broadcast();
  final StreamController<SearchEvent> _eventController =
      StreamController<SearchEvent>.broadcast();

  SearchBloc() : _state = const SearchIdleState(const []) {
    _initialize();
  }

  // Геттеры для доступа к данным
  SearchState get state => _state;
  Stream<SearchState> get stateStream => _stateController.stream;
  StreamSink<SearchEvent> get eventSink => _eventController.sink;

  void _onEmitState(SearchState state) {
    _state = state;
    _stateController.add(state);
  }

  void _initialize() {
    _onEventSubscription = _eventController.stream
        // небольшая оптимизация ввода (опционально):
        .debounceTime(const Duration(milliseconds: 300))
        .asyncExpand(_mapEventToStates)
        .listen(_onEmitState);
  }

  Stream<SearchState> _mapEventToStates(SearchEvent event) async* {
    switch (event) {
      case SearchChangedEvent():
        yield* _onSearchChanged(event);
    }
  }

  Stream<SearchState> _onSearchChanged(SearchChangedEvent event) async* {
    // Начинаем загрузку
    yield SearchLoadingState(state.results);

    try {
      // Выполняем поиск
      final results = await _fetchData(event.query, event.filter);
      yield SearchSuccessState(results);
    } on Object {
      // Обрабатываем ошибку
      yield SearchErrorState(state.results);
    } finally {
      // Возвращаемся в idle-состояние
      yield SearchIdleState(state.results);
    }
  }

  Future<List<String>> _fetchData(String query, String filter) async {
    // Та же самая фейковая реализация, что и выше.
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
      _onEventSubscription.cancel(),
      _stateController.close(),
      _eventController.close(),
    ].wait;
  }
}
