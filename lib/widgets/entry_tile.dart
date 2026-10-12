import 'package:flutter/material.dart';

import '../catalog.dart';

class EntryTile extends StatelessWidget {
  const EntryTile({
    required this.entry,
    required this.fontScale,
    required this.onTap,
    this.trailing,
    super.key,
  });

  final BookEntry entry;
  final double fontScale;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        entry.id > 591 ? entry.title : '${entry.id}  ·  ${entry.title}',
        style: TextStyle(fontSize: 16 * fontScale, fontWeight: FontWeight.w500),
      ),
      subtitle: entry.kind == EntryKind.prayer
          ? const Text('Imádság')
          : entry.kind == EntryKind.abcLiturgy
              ? const Text('Istentiszteleti rend')
              : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
