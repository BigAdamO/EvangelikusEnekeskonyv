import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScoreImage extends StatelessWidget {
  const ScoreImage({required this.stem, super.key});

  final String stem;

  Future<Uint8List?> _load() async {
    for (final extension in const ['jpg', 'png', 'jpeg', 'webp']) {
      try {
        final data = await rootBundle.load('assets/images/$stem.$extension');
        return data.buffer.asUint8List();
      } on FlutterError {
        continue;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (stem.isEmpty) return const SizedBox.shrink();
    return FutureBuilder<Uint8List?>(
      future: _load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(28),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final bytes = snapshot.data;
        if (bytes == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('A kottakép nem érhető el.'),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.memory(
              bytes,
              fit: BoxFit.fitWidth,
              width: double.infinity,
              errorBuilder: (_, __, ___) =>
                  const Text('A kottakép nem olvasható.'),
            ),
          ),
        );
      },
    );
  }
}
