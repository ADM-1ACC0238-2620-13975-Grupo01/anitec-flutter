// Feature context: application startup and dependency initialization.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/anitec_app.dart';
import 'core/i18n/locale_controller.dart';

/// Loads the shared preferences before the first frame and starts [AniTecApp] inside Riverpod.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const AniTecApp(),
    ),
  );
}
