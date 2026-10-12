import 'package:flutter/material.dart';

import '../app/app_theme.dart';

typedef SettingsChanged = Future<void> Function({
  bool? darkMode,
  double? fontScale,
});

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.darkMode,
    required this.fontScale,
    required this.onChanged,
    super.key,
  });

  final bool darkMode;
  final double fontScale;
  final SettingsChanged onChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _darkMode = widget.darkMode;
  late double _fontScale = widget.fontScale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evangélikus Énekeskönyv')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Text(
            'Beállítások',
            style: TextStyle(
              color: brandBlue,
              fontSize: 32 * _fontScale,
              fontWeight: FontWeight.w700,
              // decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(height: 28),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Sötét téma'),
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
              widget.onChanged(darkMode: value);
            },
          ),
          const SizedBox(height: 24),
          Text('Betűméret', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _fontScale.clamp(0.5, 2).toDouble(),
            min: 0.5,
            max: 2,
            divisions: 6,
            label: '${(_fontScale * 100).round()}%',
            onChanged: (value) {
              setState(() => _fontScale = value);
              widget.onChanged(fontScale: value);
            },
          ),
          Text(
            'Énekszöveg előnézete',
            style: TextStyle(
              fontSize: 18 * _fontScale,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mindenek reád néznek, Uram, hogy megadd eledelüket idejében.',
            style: TextStyle(fontSize: 18 * _fontScale, height: 1.5),
          ),
        ],
      ),
    );
  }
}
