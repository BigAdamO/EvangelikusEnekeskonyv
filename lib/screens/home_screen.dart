import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../widgets/home_action.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.fontScale,
    required this.onSearch,
    required this.onToday,
    required this.onContents,
    required this.onSettings,
    super.key,
  });

  final double fontScale;
  final VoidCallback onSearch;
  final VoidCallback onToday;
  final VoidCallback onContents;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Üdvözöljük az új Evangélikus Énekeskönyv alkalmazásban!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24 * fontScale, height: 1.25),
                ),
              ),
              const _Divider(color: brandBlue),
              Column(
                children: [
                  HomeAction(
                    title: 'Keresés',
                    fontScale: fontScale,
                    onTap: onSearch,
                  ),
                  const SizedBox(height: 24),
                  HomeAction(
                    title: 'Mai Énekek',
                    fontScale: fontScale,
                    onTap: onToday,
                  ),
                  const SizedBox(height: 24),
                  HomeAction(
                    title: 'Tartalom',
                    fontScale: fontScale,
                    onTap: onContents,
                  ),
                ],
              ),
              const _Divider(color: brandBlue),
              HomeAction(
                title: 'Beállítások',
                fontScale: fontScale,
                onTap: onSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: color,
    );
  }
}
