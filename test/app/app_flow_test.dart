import 'package:anitec_flutter/core/i18n/locale_controller.dart';
import 'package:anitec_flutter/core/network/app_error.dart';
import 'package:anitec_flutter/core/session/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fakes.dart';
import '../support/pump_app.dart';

Future<void> signIn(WidgetTester tester, [String user = 'ana']) async {
  await tester.enterText(find.byKey(const Key('username')), user);
  await tester.enterText(find.byKey(const Key('password')), 'secret');
  await tester.tap(find.text('Sign in'));
  await tester.pumpAndSettle();
}

void main() {
  late MockAuthRepository auth;

  setUp(() {
    auth = MockAuthRepository();
  });

  testWidgets('starts on sign-in in English, with a link to the terms', (
    tester,
  ) async {
    await pumpApp(tester, repos: stubRepositories(), auth: auth);

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Hello, Ana Pérez'), findsNothing);

    await tester.tap(find.text('Read the Terms of Service'));
    await tester.pumpAndSettle();
    expect(find.text('1. Purpose'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('empty fields show the required message and call nothing', (
    tester,
  ) async {
    await pumpApp(tester, repos: stubRepositories(), auth: auth);

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('This field is required'), findsNWidgets(2));
    verifyNever(() => auth.signIn(any(), any()));
  });

  testWidgets('a rancher signs in and lands on the dashboard', (tester) async {
    when(() => auth.signIn('ana', 'secret'))
        .thenAnswer((_) async => rancherSession);
    final store = InMemorySessionStore();
    await pumpApp(tester, repos: stubRepositories(), auth: auth, store: store);

    await signIn(tester);

    expect(find.text('Hello, Ana Pérez'), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing);
    expect(store.session?.token, 'token-ana');
  });

  testWidgets('a veterinarian is told this app is for ranchers', (
    tester,
  ) async {
    when(() => auth.signIn('vet', 'secret'))
        .thenAnswer((_) async => veterinarianSession);
    final store = InMemorySessionStore();
    await pumpApp(tester, repos: stubRepositories(), auth: auth, store: store);

    await signIn(tester, 'vet');

    expect(
      find.text(
        'This app is for ranchers only. Veterinarian accounts are not supported here yet.',
      ),
      findsOneWidget,
    );
    expect(find.text('Welcome back'), findsOneWidget);
    expect(store.session, isNull);
  });

  testWidgets('wrong credentials show the invalid credentials message', (
    tester,
  ) async {
    when(() => auth.signIn(any(), any()))
        .thenThrow(const AppException(ValidationError()));
    await pumpApp(tester, repos: stubRepositories(), auth: auth);

    await signIn(tester);

    expect(find.text('Invalid username or password.'), findsOneWidget);
  });

  testWidgets('a stored session opens the dashboard directly', (tester) async {
    await pumpApp(
      tester,
      repos: stubRepositories(),
      auth: auth,
      store: InMemorySessionStore(rancherSession),
    );

    expect(find.text('Hello, Ana Pérez'), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing);
  });

  testWidgets('sign out goes back to sign-in and forgets the session', (
    tester,
  ) async {
    final store = InMemorySessionStore(rancherSession);
    await pumpApp(tester, repos: stubRepositories(), auth: auth, store: store);

    await tester.tap(find.byTooltip('More options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('This field is required'), findsNothing);
    expect(
      find.text('Your session expired. Please sign in again.'),
      findsNothing,
    );
    expect(store.session, isNull);
  });

  testWidgets('an expired token (401) returns to sign-in and says why', (
    tester,
  ) async {
    final store = InMemorySessionStore(rancherSession);
    final container = await pumpApp(
      tester,
      repos: stubRepositories(),
      auth: auth,
      store: store,
    );
    expect(find.text('Hello, Ana Pérez'), findsOneWidget);

    await container.read(sessionControllerProvider.notifier).onUnauthorized();
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(
      find.text('Your session expired. Please sign in again.'),
      findsOneWidget,
    );
    expect(store.session, isNull);
  });

  testWidgets('the terms are reachable from the dashboard menu', (
    tester,
  ) async {
    await pumpApp(
      tester,
      repos: stubRepositories(),
      auth: auth,
      store: InMemorySessionStore(rancherSession),
    );

    await tester.tap(find.byTooltip('More options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terms of Service'));
    await tester.pumpAndSettle();

    expect(find.text('1. Purpose'), findsOneWidget);
  });

  testWidgets('switching to Spanish translates the app and is remembered', (
    tester,
  ) async {
    final container = await pumpApp(
      tester,
      repos: stubRepositories(),
      auth: auth,
      store: InMemorySessionStore(rancherSession),
    );
    expect(find.text('Hello, Ana Pérez'), findsOneWidget);

    await tester.tap(find.byTooltip('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Ana Pérez'), findsOneWidget);
    expect(find.text('Requieren atención'), findsOneWidget);
    // The farm selector shows its current choice in the new language too.
    expect(find.text('Todas las fincas'), findsOneWidget);
    expect(find.text('All farms'), findsNothing);
    expect(container.read(languageControllerProvider), AppLanguage.spanish);
    expect((await SharedPreferences.getInstance()).getString('language'), 'es');

    await tester.tap(find.byTooltip('Idioma'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, Ana Pérez'), findsOneWidget);
    expect(find.text('All farms'), findsOneWidget);
  });

  testWidgets('the stored language is applied on launch', (tester) async {
    await pumpApp(
      tester,
      repos: stubRepositories(),
      auth: auth,
      preferences: {'language': 'es'},
    );

    expect(find.text('Bienvenido de nuevo'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsWidgets);
  });
}
