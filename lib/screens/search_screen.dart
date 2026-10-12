import 'package:flutter/material.dart';

import '../catalog.dart';
import '../widgets/entry_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    required this.catalog,
    required this.fontScale,
    required this.onOpen,
    super.key,
  });

  final HymnCatalog catalog;
  final double fontScale;
  final ValueChanged<BookEntry> onOpen;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  bool _byNumber = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_byNumber) return;
    final id = int.tryParse(_controller.text.trim());
    final entry = id == null ? null : widget.catalog.byId(id);
    if (entry != null) widget.onOpen(entry);
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();
    final results = !_byNumber && query.isNotEmpty
        ? widget.catalog.search(query)
        : const <BookEntry>[];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _submit(),
                keyboardType:
                    _byNumber ? TextInputType.number : TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText:
                      _byNumber ? 'Énekszám' : 'Cím, első sor vagy szöveg',
                  prefixIcon: Icon(_byNumber ? Icons.tag : Icons.search),
                  suffixIcon: IconButton(
                    tooltip: 'Keresés törlése',
                    onPressed: () {
                      _controller.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.close),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _byNumber = !_byNumber),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    textStyle: TextStyle(
                      fontSize: 16 * widget.fontScale,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  child: Text(_byNumber
                      ? 'Keresés cím alapján'
                      : 'Keresés énekszám alapján'),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: FilledButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _submit();
                  },
                  child: const Text('Keresés'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _byNumber
              ? _SearchHint(fontScale: widget.fontScale)
              : results.isEmpty
                  ? Center(
                      child: Text(query.isEmpty
                          ? 'Kezdj el gépelni a kereséshez.'
                          : 'Nincs találat.'),
                    )
                  : ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: results.length,
                      itemBuilder: (context, index) => EntryTile(
                        entry: results[index],
                        fontScale: widget.fontScale,
                        onTap: () => widget.onOpen(results[index]),
                      ),
                    ),
        ),
      ],
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint({required this.fontScale});

  final double fontScale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Text(
          'Írd be az énekszámot, majd nyomd meg az Entert vagy a Megnyitás gombot.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16 * fontScale),
        ),
      ),
    );
  }
}
