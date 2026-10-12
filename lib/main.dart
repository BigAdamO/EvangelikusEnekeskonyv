import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/evangelikus_app.dart';
import 'catalog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final results = await Future.wait([
    HymnCatalog.load(),
    SharedPreferences.getInstance(),
  ]);
  runApp(EvangelikusApp(
    catalog: results[0] as HymnCatalog,
    preferences: results[1] as SharedPreferences,
  ));
}
