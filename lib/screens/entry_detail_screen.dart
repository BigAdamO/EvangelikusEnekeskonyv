import 'package:flutter/material.dart';

import '../catalog.dart';
import '../widgets/liturgy_text.dart';
import '../widgets/score_image.dart';

class EntryDetailScreen extends StatefulWidget {
  const EntryDetailScreen({
    required this.catalog,
    required this.entry,
    required this.fontScale,
    this.sequence,
    super.key,
  });

  final HymnCatalog catalog;
  final BookEntry entry;
  final double fontScale;
  final List<BookEntry>? sequence;

  @override
  State<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  late final List<BookEntry> _sequence;
  late final PageController _pageController;
  late int _currentIndex;
  Offset? _pointerDownPosition;

  @override
  void initState() {
    super.initState();
    final sequence = widget.sequence ?? widget.catalog.songbookEntries;
    _sequence = sequence.any((entry) => entry.id == widget.entry.id)
        ? sequence
        : [widget.entry];
    _currentIndex =
        _sequence.indexWhere((entry) => entry.id == widget.entry.id);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evangélikus Énekeskönyv')),
      body: Listener(
        onPointerDown: (event) => _pointerDownPosition = event.position,
        onPointerUp: (event) {
          final start = _pointerDownPosition;
          _pointerDownPosition = null;
          if (start == null) return;
          final delta = event.position - start;
          if (delta.dx.abs() < 60 || delta.dx.abs() <= delta.dy.abs()) return;
          _showPage(_currentIndex + (delta.dx < 0 ? 1 : -1));
        },
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _sequence.length,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemBuilder: _buildEntryPage,
        ),
      ),
    );
  }

  Widget _buildEntryPage(BuildContext context, int index) {
    final entry = _sequence[index];
    final title = entry.id > 591 ? entry.title : '${entry.id} ${entry.title}';
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 36),
      children: [
        if (_sequence.length > 1)
          Row(
            children: [
              IconButton(
                tooltip: 'Előző',
                onPressed: index > 0 ? () => _showPage(index - 1) : null,
                icon: const Icon(Icons.chevron_left, size: 36),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22 * widget.fontScale,
                    height: 1.2,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Következő',
                onPressed: index < _sequence.length - 1
                    ? () => _showPage(index + 1)
                    : null,
                icon: const Icon(Icons.chevron_right, size: 36),
              ),
            ],
          ),
        if (_sequence.length <= 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28 * widget.fontScale,
                height: 1.2,
              ),
            ),
          ),
        ..._buildEntryContent(context, entry),
      ],
    );
  }

  void _showPage(int index) {
    if (index < 0 || index >= _sequence.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
    );
  }

  List<Widget> _buildEntryContent(BuildContext context, BookEntry entry) {
    final data = entry.data;
    final widgets = <Widget>[];
    if (entry.kind == EntryKind.song) {
      widgets.add(ScoreImage(stem: data['sheets']?.toString() ?? ''));
    } else if (entry.kind == EntryKind.liturgy) {
      for (var part = 1; part <= 3; part++) {
        final title = data['title$part']?.toString() ?? '';
        if (title.isNotEmpty) widgets.add(SectionHeading(title));
        final sheet = data['sheets$part']?.toString() ?? '';
        if (sheet.isNotEmpty) widgets.add(ScoreImage(stem: sheet));
      }
    } else if (entry.kind == EntryKind.extendedLiturgy) {
      const headings = {
        'dicsoseg': 'Dicsőség',
        'uramIrgalmazz': 'Uram, irgalmazz',
        'dicsoseg2': 'Dicsőség',
        'szentASeregekUra': 'Szent a seregek Ura',
        'krisztusIstenBaranya': 'Krisztus, Isten Báránya',
      };
      for (final field in headings.entries) {
        final stem = data[field.key]?.toString() ?? '';
        if (stem.isNotEmpty) {
          widgets.add(SectionHeading(field.value));
          widgets.add(ScoreImage(stem: stem));
        }
      }
    } else if (entry.kind == EntryKind.dailyLiturgy) {
      widgets.add(const SectionHeading('Mindennapi istentiszteleti rend'));
      widgets.add(const LiturgyText('1. Ének'));
      widgets.add(const LiturgyText(
        '2. Bevezetés\n\nLelkész: Az Atya, Fiú, Szentlélek nevében.\n\nGyülekezet:',
      ));
      widgets.addAll(const [
        ScoreImage(stem: 'l_amen'),
        ScoreImage(stem: 'l_17_uram_nyisd_meg')
      ]);
      widgets.add(const LiturgyText('3. Zsoltár\n\nLelkész: zsoltárt olvas.'));
      widgets.add(const ScoreImage(stem: 'l_14_dicsoseg_az_atyanak'));
      widgets.add(const LiturgyText(
        'Vagy: a gyülekezet zsoltárt olvas vagy énekel a kitűzött énekszám szerint.\n\n'
        '4. Imádság\n\nLelkész: Az Úr legyen veletek!\n\nGyülekezet:',
      ));
      widgets.addAll(const [
        ScoreImage(stem: 'l_17_es_a_te_lelkeddel'),
        LiturgyText('Lelkész: imádságot olvas.'),
        ScoreImage(stem: 'l_17_teremts_bennem'),
      ]);
      widgets.add(const LiturgyText(
        '5. Igeolvasás\n\nLelkész: szentírási igét olvas, azután ezt mondja: '
        'Boldogok, akik hallgatják és megtartják Isten beszédét.',
      ));
      widgets.addAll(const [
        ScoreImage(stem: 'l_halleluja'),
        LiturgyText('Böjtben a halleluja elmarad, helyette:'),
        ScoreImage(stem: 'l_amen2'),
        LiturgyText(
          'Vagy: Lelkész: Áldjuk az Urat, mert irgalmas, és beszéde megmarad örökké.\n\nGyülekezet:',
        ),
        ScoreImage(stem: 'l_aldunk_teged'),
      ]);
      widgets.add(const LiturgyText(
        '6. Igehirdetés\n\n7. Dicséret\n\nGyülekezet: Istent, Krisztust dicsőítő éneket vagy énekverset énekel.\n\n'
        '8. Befejezés\n\nLelkész: befejező imádságot olvas, azután ezt mondja: '
        'Uram, hallgasd meg imádságomat, és jusson el hozzád kiáltásom!',
      ));
      widgets.addAll(const [
        ScoreImage(stem: 'l_14_uram_irgalmazz'),
        LiturgyText(
          'Lelkész és gyülekezet: együtt mondják a Miatyánkot.\n\nLelkész: az ároni áldást mondja.\n\nGyülekezet:',
        ),
        ScoreImage(stem: 'l_amen2'),
        LiturgyText(
            'Vagy: a lelkész a szentháromsági áldást énekli.\n\nGyülekezet:'),
        ScoreImage(stem: 'l_amen'),
        LiturgyText('(Ének)'),
      ]);
    } else if (entry.kind == EntryKind.abcLiturgy) {
      widgets.add(const SectionHeading('Istentiszteleti rend'));
    }

    if (entry.text.isNotEmpty) {
      widgets.add(const SizedBox(height: 14));
      widgets.add(SelectableText(
        entry.text,
        textAlign:
            entry.kind == EntryKind.prayer ? TextAlign.center : TextAlign.start,
        style: TextStyle(fontSize: 19 * widget.fontScale, height: 1.55),
      ));
    }
    return widgets;
  }
}
