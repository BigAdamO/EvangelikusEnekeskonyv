import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../catalog.dart';
import '../widgets/entry_tile.dart';

class ContentsScreen extends StatelessWidget {
  const ContentsScreen({
    required this.catalog,
    required this.fontScale,
    required this.onOpen,
    super.key,
  });

  final HymnCatalog catalog;
  final double fontScale;
  final ValueChanged<BookEntry> onOpen;

  @override
  Widget build(BuildContext context) {
    final sections = catalog.sections;
    final rowCount = sections.fold<int>(
      0,
      (count, section) => count + section.entries.length + 1,
    );
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: rowCount,
      itemBuilder: (context, index) {
        var row = index;
        for (final section in sections) {
          if (row == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
              child: Text(
                section.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: brandBlue,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            );
          }
          row -= 1;
          if (row < section.entries.length) {
            final entry = section.entries[row];
            return EntryTile(
              entry: entry,
              fontScale: fontScale,
              onTap: () => onOpen(entry),
            );
          }
          row -= section.entries.length;
        }
        return const SizedBox.shrink();
      },
    );
  }
}
