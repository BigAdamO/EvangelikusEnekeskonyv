import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../catalog.dart';
import '../navigation/app_routes.dart';
import '../screens/book_home_screen.dart';
import 'app_theme.dart';

class EvangelikusApp extends StatefulWidget {
  const EvangelikusApp({
    required this.catalog,
    required this.preferences,
    super.key,
  });

  final HymnCatalog catalog;
  final SharedPreferences preferences;

  @override
  State<EvangelikusApp> createState() => _EvangelikusAppState();
}

class _EvangelikusAppState extends State<EvangelikusApp> {
  late bool _darkMode = widget.preferences.getBool('darkMode') ?? false;
  late final ValueNotifier<double> _fontScale = ValueNotifier(
    widget.preferences.getDouble('fontScale') ?? 1,
  );

  Future<void> _updateSettings({bool? darkMode, double? fontScale}) async {
    if (darkMode != null) {
      setState(() => _darkMode = darkMode);
      await widget.preferences.setBool('darkMode', darkMode);
    }
    if (fontScale != null) {
      _fontScale.value = fontScale;
      setState(() {});
      await widget.preferences.setDouble('fontScale', fontScale);
    }
  }

  @override
  void dispose() {
    _fontScale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontScale = _fontScale.value;
    return MaterialApp(
      title: 'Evangélikus Énekeskönyv',
      debugShowCheckedModeBanner: false,
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.light(fontScale),
      darkTheme: AppTheme.dark(fontScale),
      home: BookHomeScreen(
        catalog: widget.catalog,
        preferences: widget.preferences,
        fontScale: _fontScale,
      ),
      onGenerateRoute: (routeSettings) => AppRoutes.onGenerateRoute(
        routeSettings: routeSettings,
        catalog: widget.catalog,
        darkMode: _darkMode,
        fontScale: fontScale,
        onSettingsChanged: _updateSettings,
      ),
    );
  }
}
