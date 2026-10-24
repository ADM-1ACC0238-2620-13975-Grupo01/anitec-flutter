import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported UI languages. `code` is what gets stored.
enum AppLanguage {
  english('en', Locale('en')),
  spanish('es', Locale.fromSubtags(languageCode: 'es', countryCode: '419'));

  const AppLanguage(this.code, this.locale);

  final String code;
  final Locale locale;

  static AppLanguage fromCode(String? code) => values.firstWhere(
    (language) => language.code == code,
    orElse: () => english,
  );
}

/// Overridden in `main` with the loaded instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider not overridden'),
);

final languageControllerProvider =
    NotifierProvider<LanguageController, AppLanguage>(LanguageController.new);

/// In-app language switch. The course statement requires English by default, so the device
/// language is ignored until the user picks one.
class LanguageController extends Notifier<AppLanguage> {
  static const _key = 'language';

  @override
  AppLanguage build() =>
      AppLanguage.fromCode(ref.read(sharedPreferencesProvider).getString(_key));

  Future<void> select(AppLanguage language) async {
    state = language;
    await ref.read(sharedPreferencesProvider).setString(_key, language.code);
  }
}
