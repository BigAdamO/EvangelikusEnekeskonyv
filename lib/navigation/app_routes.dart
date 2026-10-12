import 'package:flutter/material.dart';

import '../catalog.dart';
import '../screens/entry_detail_screen.dart';
import '../screens/settings_screen.dart';

abstract final class AppRoutes {
  static const settings = '/settings';
  static const entryPrefix = '/entry';

  static String entry(int id) => '$entryPrefix/$id';

  static Route<dynamic> onGenerateRoute({
    required RouteSettings routeSettings,
    required HymnCatalog catalog,
    required bool darkMode,
    required double fontScale,
    required SettingsChanged onSettingsChanged,
  }) {
    final routeName = routeSettings.name ?? '/';
    final sequence = routeSettings.arguments;
    if (routeName == settings) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => SettingsScreen(
          darkMode: darkMode,
          fontScale: fontScale,
          onChanged: onSettingsChanged,
        ),
      );
    }

    if (routeName.startsWith('$entryPrefix/')) {
      final id = int.tryParse(routeName.substring(entryPrefix.length + 1));
      final entry = id == null ? null : catalog.byId(id);
      if (entry != null) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (_) => EntryDetailScreen(
            catalog: catalog,
            entry: entry,
            fontScale: fontScale,
            sequence: sequence is List<BookEntry> ? sequence : null,
          ),
        );
      }
    }

    return MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (_) => const Scaffold(
        body: Center(child: Text('Ez az oldal nem található.')),
      ),
    );
  }
}
