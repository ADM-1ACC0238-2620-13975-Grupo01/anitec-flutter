import 'package:anitec_flutter/core/i18n/locale_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> containerWith(Map<String, Object> stored) async {
  SharedPreferences.setMockInitialValues(stored);
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(
        await SharedPreferences.getInstance(),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('English is the default, whatever the device language is', () async {
    final container = await containerWith({});
    final language = container.read(languageControllerProvider);
    expect(language, AppLanguage.english);
    expect(language.locale, const Locale('en'));
  });

  test('Spanish uses the Latin American locale', () {
    expect(AppLanguage.spanish.locale.languageCode, 'es');
    expect(AppLanguage.spanish.locale.countryCode, '419');
  });

  test('the stored choice is restored', () async {
    final container = await containerWith({'language': 'es'});
    expect(container.read(languageControllerProvider), AppLanguage.spanish);
  });

  test('an unknown stored value falls back to English', () async {
    final container = await containerWith({'language': 'fr'});
    expect(container.read(languageControllerProvider), AppLanguage.english);
  });

  test('selecting a language changes it and persists it', () async {
    final container = await containerWith({});

    await container
        .read(languageControllerProvider.notifier)
        .select(AppLanguage.spanish);

    expect(container.read(languageControllerProvider), AppLanguage.spanish);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('language'), 'es');
  });
}
