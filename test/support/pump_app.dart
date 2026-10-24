import 'package:anitec_flutter/activities/activities_providers.dart';
import 'package:anitec_flutter/app/anitec_app.dart';
import 'package:anitec_flutter/app/home/home_controller.dart';
import 'package:anitec_flutter/core/designsystem/theme.dart';
import 'package:anitec_flutter/core/i18n/locale_controller.dart';
import 'package:anitec_flutter/core/session/session_controller.dart';
import 'package:anitec_flutter/iam/iam_providers.dart';
import 'package:anitec_flutter/l10n/app_localizations.dart';
import 'package:anitec_flutter/livestock/livestock_providers.dart';
import 'package:anitec_flutter/sanitary/sanitary_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

/// Tall enough for the whole dashboard to be built by the lazy list. Pull-to-refresh needs a drag
/// of a quarter of the height, so tests that pull use a shorter screen.
void useTallScreen(WidgetTester tester, {double height = 2400}) {
  tester.view.physicalSize = Size(420, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<List<Override>> baseOverrides({
  Map<String, Object> preferences = const {},
  required ({
    MockLivestockRepository livestock,
    MockSanitaryRepository sanitary,
    MockActivitiesRepository activities,
  })
  repos,
}) async {
  SharedPreferences.setMockInitialValues(preferences);
  return [
    sharedPreferencesProvider.overrideWithValue(
      await SharedPreferences.getInstance(),
    ),
    livestockRepositoryProvider.overrideWithValue(repos.livestock),
    sanitaryRepositoryProvider.overrideWithValue(repos.sanitary),
    activitiesRepositoryProvider.overrideWithValue(repos.activities),
    clockProvider.overrideWithValue(() => today),
  ];
}

/// A single screen, localized and themed, signed in as the rancher.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  required ({
    MockLivestockRepository livestock,
    MockSanitaryRepository sanitary,
    MockActivitiesRepository activities,
  })
  repos,
  Locale locale = const Locale('en'),
  double height = 2400,
}) async {
  useTallScreen(tester, height: height);
  final overrides = await baseOverrides(repos: repos);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...overrides,
        sessionControllerProvider.overrideWith(
          () => SignedInSessionController(rancherSession),
        ),
      ],
      child: MaterialApp(
        theme: buildAniTecTheme(),
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: screen,
      ),
    ),
  );
}

/// The whole app with the real router and session, but fake network.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  required ({
    MockLivestockRepository livestock,
    MockSanitaryRepository sanitary,
    MockActivitiesRepository activities,
  })
  repos,
  required MockAuthRepository auth,
  InMemorySessionStore? store,
  Map<String, Object> preferences = const {},
}) async {
  useTallScreen(tester);
  final overrides = await baseOverrides(preferences: preferences, repos: repos);
  final container = ProviderContainer(
    overrides: [
      ...overrides,
      authRepositoryProvider.overrideWithValue(auth),
      sessionStoreProvider.overrideWithValue(store ?? InMemorySessionStore()),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const AniTecApp()),
  );
  await tester.pumpAndSettle();
  return container;
}
