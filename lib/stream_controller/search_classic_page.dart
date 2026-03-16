import 'package:flight_survey/stream_controller/simple_search_bloc/simple_search_bloc.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: Scaffold(body: SearchClassicPage())));
}

class SearchClassicPage extends StatefulWidget {
  const SearchClassicPage({super.key});

  @override
  State<SearchClassicPage> createState() => _SearchClassicPageState();
}

class _SearchClassicPageState extends State<SearchClassicPage> {
  late final SearchBLoC _bloc;

  final TextEditingController _queryController = TextEditingController();

  final List<String> _filters = <String>['', 'flutter', 'state'];
  String _selectedFilter = '';

  @override
  void initState() {
    super.initState();
    _bloc = SearchBLoC();
  }

  @override
  void dispose() {
    _queryController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onChanged() {
    _bloc.searchSink.add(_queryController.text);
    _bloc.filterSink.add(_selectedFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search demo (classic BLoC)')),
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
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
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
            StreamBuilder<bool>(
              stream: _bloc.isLoadingStream,
              initialData: _bloc.isLoading,
              builder: (BuildContext context, AsyncSnapshot<bool> loadingSnap) {
                final bool isLoading = loadingSnap.data ?? false;
                return Expanded(
                  child: Stack(
                    children: <Widget>[
                      StreamBuilder<List<String>>(
                        stream: _bloc.resultsStream,
                        initialData: _bloc.results,
                        builder:
                            (
                              BuildContext context,
                              AsyncSnapshot<List<String>> resultsSnap,
                            ) {
                              final List<String> results =
                                  resultsSnap.data ?? const [];

                              if (results.isEmpty && !isLoading) {
                                return const Center(child: Text('No results'));
                              }

                              return ListView.separated(
                                itemCount: results.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (BuildContext context, int index) {
                                  final String item = results[index];
                                  return ListTile(title: Text(item));
                                },
                              );
                            },
                      ),
                      if (isLoading)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
