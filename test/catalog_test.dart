import 'package:evangelikus_enekeskonyv/catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:evangelikus_enekeskonyv/navigation/app_routes.dart';
import 'package:evangelikus_enekeskonyv/screens/book_home_screen.dart';
import 'package:evangelikus_enekeskonyv/screens/contents_screen.dart';
import 'package:evangelikus_enekeskonyv/screens/entry_detail_screen.dart';
import 'package:evangelikus_enekeskonyv/screens/settings_screen.dart';
import 'package:evangelikus_enekeskonyv/screens/today_screen.dart';
import 'package:evangelikus_enekeskonyv/widgets/entry_tile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HymnCatalog catalog;

  setUpAll(() async {
    catalog = await HymnCatalog.load();
  });

  test('loads all hymn, liturgy, and prayer collections', () {
    expect(catalog.entries, hasLength(601));
    expect(catalog.prayers, hasLength(4));
  });

  test('finds entries by id across their source collections', () {
    expect(catalog.byId(18)?.title, '25. zsoltár');
    expect(catalog.byId(14)?.kind, EntryKind.extendedLiturgy);
    expect(catalog.byId(1001)?.kind, EntryKind.abcLiturgy);
    expect(catalog.byId(2300)?.title, 'Apostoli hitvallás');
    expect(catalog.byId(-1), isNull);
  });

  test('organizes the catalog into the requested sections', () {
    expect(
      catalog.sections.map((section) => section.title),
      [
        'Hitvallások',
        'Imádságok',
        'Istentiszteleti rendek',
        'Liturgiák',
        'Zsoltárok',
        'Énekek',
      ],
    );
    expect(catalog.sections.map((section) => section.entries.length),
        [2, 2, 10, 17, 22, 552]);
  });

  test('searches titles and lyrics without case sensitivity', () {
    expect(catalog.search('25. ZSOLTÁR').single.id, 18);
    expect(
        catalog.search('hozzád emelem').map((entry) => entry.id), contains(18));
    expect(catalog.search('no such hymn'), isEmpty);
  });

  testWidgets('settings controls immediately reflect and dispatch changes',
      (tester) async {
    bool? changedDarkMode;
    double? changedFontScale;

    await tester.pumpWidget(MaterialApp(
      home: SettingsScreen(
        darkMode: false,
        fontScale: 1,
        onChanged: ({bool? darkMode, double? fontScale}) async {
          changedDarkMode = darkMode;
          changedFontScale = fontScale;
        },
      ),
    ));

    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();
    expect(changedDarkMode, isTrue);
    expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
        isTrue);

    await tester.drag(find.byType(Slider), const Offset(120, 0));
    await tester.pump();
    expect(changedFontScale, isNotNull);
    expect(changedFontScale, greaterThan(1));
    expect(tester.widget<Slider>(find.byType(Slider)).value, greaterThan(1));
  });

  testWidgets('named entry route opens the selected hymn', (tester) async {
    await tester.pumpWidget(MaterialApp(
      onGenerateRoute: (settings) => AppRoutes.onGenerateRoute(
        routeSettings: settings,
        catalog: catalog,
        darkMode: false,
        fontScale: 1,
        onSettingsChanged: ({bool? darkMode, double? fontScale}) async {},
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.entry(18)),
            child: const Text('Open hymn'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Open hymn'));
    await tester.pumpAndSettle();

    expect(find.text('18 25. zsoltár'), findsOneWidget);
    expect(find.textContaining('Hozzád emelem'), findsOneWidget);
  });

  testWidgets('hymn detail can be changed by swiping horizontally',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: EntryDetailScreen(
        catalog: catalog,
        entry: catalog.byId(18)!,
        fontScale: 1,
      ),
    ));

    await tester.tap(find.byTooltip('Következő'));
    await tester.pumpAndSettle();
    expect(find.text('19 ${catalog.byId(19)!.title}'), findsOneWidget);

    final pageBounds = tester.getRect(find.byType(PageView));
    await tester.dragFrom(
      Offset(pageBounds.right - 40, pageBounds.center.dy),
      Offset(-pageBounds.width * 0.75, 0),
    );
    await tester.pumpAndSettle();

    expect(find.text('20 ${catalog.byId(20)!.title}'), findsOneWidget);
  });

  testWidgets('system back from search returns to the home screen',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final fontScale = ValueNotifier(1.0);
    addTearDown(fontScale.dispose);

    await tester.pumpWidget(MaterialApp(
      home: BookHomeScreen(
        catalog: catalog,
        preferences: preferences,
        fontScale: fontScale,
      ),
    ));
    await tester.tap(find.text('Keresés'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(
      find.text('Üdvözöljük az új Evangélikus Énekeskönyv alkalmazásban!'),
      findsOneWidget,
    );
  });

  testWidgets('back from a hymn opened through search restores search',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final fontScale = ValueNotifier(1.0);
    addTearDown(fontScale.dispose);

    await tester.pumpWidget(MaterialApp(
      home: BookHomeScreen(
        catalog: catalog,
        preferences: preferences,
        fontScale: fontScale,
      ),
      onGenerateRoute: (settings) => AppRoutes.onGenerateRoute(
        routeSettings: settings,
        catalog: catalog,
        darkMode: false,
        fontScale: 1,
        onSettingsChanged: ({bool? darkMode, double? fontScale}) async {},
      ),
    ));
    await tester.tap(find.text('Keresés'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '18');
    await tester.tap(find.widgetWithText(FilledButton, 'Keresés'));
    await tester.pumpAndSettle();

    expect(find.text('18 25. zsoltár'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Keresés cím alapján'), findsOneWidget);
  });

  testWidgets('catalog has grouped headings and no search field',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ContentsScreen(
          catalog: catalog,
          fontScale: 1,
          onOpen: (_) {},
        ),
      ),
    ));

    expect(find.byType(TextField), findsNothing);
    expect(find.text('Hitvallások'), findsOneWidget);
  });

  testWidgets('special catalog entries display without their internal IDs',
      (tester) async {
    final entry = catalog.byId(1001)!;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EntryTile(entry: entry, fontScale: 1, onTap: () {}),
      ),
    ));

    expect(find.text(entry.title), findsOneWidget);
    expect(find.textContaining('1001'), findsNothing);
  });

  testWidgets('list-start action passes saved songs in their selected order',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'todayIds': ['18', '20'],
    });
    final preferences = await SharedPreferences.getInstance();
    List<BookEntry>? started;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TodayScreen(
          catalog: catalog,
          preferences: preferences,
          fontScale: 1,
          onOpen: (_) {},
          onStart: (entries) => started = entries,
        ),
      ),
    ));

    await tester.tap(find.text('Lista indítása'));
    expect(started?.map((entry) => entry.id), [18, 20]);
  });
}
