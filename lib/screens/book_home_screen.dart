import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../catalog.dart';
import '../navigation/app_routes.dart';
import 'contents_screen.dart';
import 'search_screen.dart';
import 'today_screen.dart';
import 'home_screen.dart';

class BookHomeScreen extends StatefulWidget {
  const BookHomeScreen({
    required this.catalog,
    required this.preferences,
    required this.fontScale,
    super.key,
  });

  final HymnCatalog catalog;
  final SharedPreferences preferences;
  final ValueListenable<double> fontScale;

  @override
  State<BookHomeScreen> createState() => _BookHomeScreenState();
}

class _BookHomeScreenState extends State<BookHomeScreen> {
  int _tab = 0;

  void _openEntry(BookEntry entry) {
    Navigator.of(context).pushNamed(AppRoutes.entry(entry.id));
  }

  void _startSongs(List<BookEntry> entries) {
    if (entries.isEmpty) return;
    Navigator.of(context).pushNamed(
      AppRoutes.entry(entries.first.id),
      arguments: entries,
    );
  }

  void _openSettings() {
    Navigator.of(context).pushNamed(AppRoutes.settings);
  }

  void _goHome() => setState(() => _tab = 0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.fontScale,
      builder: (context, fontScale, _) => _buildScaffold(context, fontScale),
    );
  }

  Widget _buildScaffold(BuildContext context, double fontScale) {
    return PopScope<Object?>(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _tab != 0) _goHome();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: _tab == 0
              ? null
              : IconButton(
                  tooltip: 'Vissza',
                  onPressed: _goHome,
                  icon: const Icon(Icons.arrow_back),
                ),
          title: const Text(
            'Evangélikus Énekeskönyv',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: IndexedStack(
          index: _tab,
          children: [
            HomeScreen(
              fontScale: fontScale,
              onSearch: () => setState(() => _tab = 1),
              onToday: () => setState(() => _tab = 2),
              onContents: () => setState(() => _tab = 3),
              onSettings: _openSettings,
            ),
            SearchScreen(
              catalog: widget.catalog,
              fontScale: fontScale,
              onOpen: _openEntry,
            ),
            TodayScreen(
              catalog: widget.catalog,
              preferences: widget.preferences,
              fontScale: fontScale,
              onOpen: _openEntry,
              onStart: _startSongs,
            ),
            ContentsScreen(
              catalog: widget.catalog,
              fontScale: fontScale,
              onOpen: _openEntry,
            ),
          ],
        ),
      ),
    );
  }
}
