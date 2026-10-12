import 'dart:convert';

import 'package:flutter/services.dart';

enum EntryKind {
  song,
  liturgy,
  extendedLiturgy,
  dailyLiturgy,
  abcLiturgy,
  prayer
}

class BookEntry {
  const BookEntry({
    required this.id,
    required this.title,
    required this.kind,
    required this.data,
  });

  final int id;
  final String title;
  final EntryKind kind;
  final Map<String, dynamic> data;

  String get text => (data['lyrics'] ?? data['content'] ?? '').toString();

  factory BookEntry.fromJson(Map<String, dynamic> json, EntryKind kind) {
    return BookEntry(
      id: int.parse(json['id'].toString()),
      title: json['title']?.toString() ?? '',
      kind: kind,
      data: json,
    );
  }
}

class CatalogSection {
  const CatalogSection({required this.title, required this.entries});

  final String title;
  final List<BookEntry> entries;
}

class HymnCatalog {
  const HymnCatalog({required this.entries, required this.prayers});

  final List<BookEntry> entries;
  final List<BookEntry> prayers;

  List<BookEntry> _entriesInRange(int firstId, int lastId) => [
        for (final entry in [...entries, ...prayers])
          if (entry.id >= firstId && entry.id <= lastId) entry,
      ]..sort((a, b) => a.id.compareTo(b.id));

  List<CatalogSection> get sections => [
        CatalogSection(
          title: 'Hitvallások',
          entries: _entriesInRange(2300, 2301),
        ),
        CatalogSection(
          title: 'Imádságok',
          entries: _entriesInRange(2000, 2001),
        ),
        CatalogSection(
          title: 'Istentiszteleti rendek',
          entries: _entriesInRange(1001, 1010),
        ),
        CatalogSection(
          title: 'Liturgiák',
          entries: _entriesInRange(1, 17),
        ),
        CatalogSection(
          title: 'Zsoltárok',
          entries: _entriesInRange(18, 39),
        ),
        CatalogSection(
          title: 'Énekek',
          entries: _entriesInRange(40, 591),
        ),
      ];

  List<BookEntry> get songbookEntries =>
      entries.where((entry) => entry.id <= 591).toList(growable: false);

  static Future<HymnCatalog> load() async {
    Future<List<BookEntry>> read(String file, EntryKind kind) async {
      final source = await rootBundle.loadString('assets/data/$file');
      final decoded = jsonDecode(source) as List<dynamic>;
      return decoded
          .map((item) => BookEntry.fromJson(
                Map<String, dynamic>.from(item as Map),
                kind,
              ))
          .toList(growable: false);
    }

    final groups = await Future.wait([
      read('liturgy.json', EntryKind.liturgy),
      read('liturgy14.json', EntryKind.extendedLiturgy),
      read('liturgy17.json', EntryKind.dailyLiturgy),
      read('liturgy_abc.json', EntryKind.abcLiturgy),
      read('songs.json', EntryKind.song),
      read('prayer.json', EntryKind.prayer),
    ]);

    final entries = groups.take(5).expand((group) => group).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    return HymnCatalog(entries: entries, prayers: groups.last);
  }

  BookEntry? byId(int id) {
    for (final entry in [...entries, ...prayers]) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  List<BookEntry> search(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return const [];
    return [...entries, ...prayers]
        .where((entry) =>
            entry.title.toLowerCase().contains(needle) ||
            entry.text.toLowerCase().contains(needle))
        .toList(growable: false);
  }
}
