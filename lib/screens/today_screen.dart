import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../catalog.dart';
import '../widgets/entry_tile.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({
    required this.catalog,
    required this.preferences,
    required this.fontScale,
    required this.onOpen,
    required this.onStart,
    super.key,
  });

  final HymnCatalog catalog;
  final SharedPreferences preferences;
  final double fontScale;
  final ValueChanged<BookEntry> onOpen;
  final ValueChanged<List<BookEntry>> onStart;

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  late final TextEditingController _controller;
  late List<int> _ids;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _ids = (widget.preferences.getStringList('todayIds') ?? [])
        .map(int.tryParse)
        .whereType<int>()
        .take(5)
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() => widget.preferences.setStringList(
        'todayIds',
        _ids.map((id) => id.toString()).toList(),
      );

  void _addSong() {
    final id = int.tryParse(_controller.text.trim());
    if (_ids.length >= 5 ||
        id == null ||
        id < 1 ||
        id > 591 ||
        _ids.contains(id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adj meg egy érvényes, még nem szereplő énekszámot.'),
        ),
      );
      return;
    }
    setState(() {
      _ids.add(id);
      _controller.clear();
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final entries = _ids
        .map(widget.catalog.byId)
        .whereType<BookEntry>()
        .toList(growable: false);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addSong(),
                decoration: const InputDecoration(
                  labelText: 'Énekszám',
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: FilledButton(
                  onPressed: _addSong,
                  child: const Text('Felvesz'),
                ),
              ),
              const SizedBox(height: 16),
              if (_ids.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('Még nincs ének a listában.')),
                ),
              for (final entry in entries)
                EntryTile(
                  entry: entry,
                  fontScale: widget.fontScale,
                  onTap: () => widget.onOpen(entry),
                  trailing: IconButton(
                    tooltip: 'Eltávolítás',
                    onPressed: () {
                      setState(() => _ids.remove(entry.id));
                      _save();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              if (_ids.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(_ids.clear);
                      _save();
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Lista törlése'),
                  ),
                ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed:
                    entries.isEmpty ? null : () => widget.onStart(entries),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Lista indítása'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
