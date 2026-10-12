import 'package:flutter/material.dart';

class HomeAction extends StatelessWidget {
  const HomeAction({
    required this.title,
    required this.fontScale,
    required this.onTap,
    super.key,
  });

  final String title;
  final double fontScale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        textStyle: TextStyle(fontSize: 18 * fontScale),
      ),
      child: Text(title),
    );
  }
}
