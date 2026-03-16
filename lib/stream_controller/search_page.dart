import 'package:flight_survey/stream_controller/search_bloc/event.dart';
import 'package:flight_survey/stream_controller/search_bloc/search_bloc.dart';
import 'package:flight_survey/stream_controller/search_bloc/state.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: Scaffold(body: SearchPage())));
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchBloc _bloc;

  final TextEditingController _queryController = TextEditingController();

  final List<String> _filters = <String>['', 'flutter', 'state'];
  String _selectedFilter = '';

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc();
  }

  @override
  void dispose() {
    _queryController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onChanged() {
    _bloc.eventSink.add(
      SearchChangedEvent(query: _queryController.text, filter: _selectedFilter),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search demo (BLoC)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                labelText: 'Search query',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _onChanged(),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                const Text('Filter:'),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: _filters
                      .map(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.isEmpty ? '(none)' : value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    if (value == null) return;
                    setState(() {
                      _selectedFilter = value;
                    });
                    _onChanged();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<SearchState>(
                stream: _bloc.stateStream,
                initialData: _bloc.state,
                builder:
                    (BuildContext context, AsyncSnapshot<SearchState> snap) {
                      final SearchState state = snap.data ?? _bloc.state;

                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is SearchErrorState) {
                        return const Center(
                          child: Text('Error while searching'),
                        );
                      }

                      if (state.results.isEmpty) {
                        return const Center(child: Text('No results'));
                      }

                      return ListView.separated(
                        itemCount: state.results.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (BuildContext context, int index) {
                          final String item = state.results[index];
                          return ListTile(title: Text(item));
                        },
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
