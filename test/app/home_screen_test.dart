import 'package:anitec_flutter/app/home/home_screen.dart';
import 'package:anitec_flutter/core/designsystem/components.dart';
import 'package:anitec_flutter/core/network/app_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../support/fakes.dart';
import '../support/pump_app.dart';

/// The value text inside the metric card with this label.
Finder metricValue(String label, String value) => find.descendant(
  of: find.widgetWithText(MetricCard, label),
  matching: find.text(value),
);

Future<void> pullToRefresh(WidgetTester tester) async {
  await tester.drag(find.byType(ListView), const Offset(0, 700));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the greeting, counters and the rancher\'s own records', (
    tester,
  ) async {
    await pumpScreen(tester, const HomeScreen(), repos: stubRepositories());
    await tester.pumpAndSettle();

    expect(find.text('Hello, Ana Pérez'), findsOneWidget);
    expect(find.text('Rancher'), findsOneWidget);
    expect(metricValue('Animals', '3'), findsOneWidget);
    expect(metricValue('Need attention', '2'), findsOneWidget);
    expect(metricValue('Health records', '2'), findsOneWidget);
    expect(metricValue('Pending follow-ups', '1'), findsOneWidget);
    expect(metricValue('Upcoming activities', '1'), findsOneWidget);

    // Upcoming activities and recent records, without anybody else's data.
    expect(find.text('Foot-and-mouth vaccination'), findsOneWidget);
    expect(find.text('Somebody else task'), findsNothing);
    expect(find.text('Forgotten visit'), findsNothing);
    expect(find.text('Tita'), findsOneWidget);
    expect(find.text('Luna'), findsOneWidget);
    expect(find.text('Of a foreign animal'), findsNothing);
    expect(find.text('Follow-up'), findsOneWidget);
    expect(find.text('Closed'), findsOneWidget);
    expect(find.text('High'), findsOneWidget);
    expect(find.text('Type: Health', findRichText: true), findsOneWidget);
  });

  testWidgets('renders in Spanish', (tester) async {
    await pumpScreen(
      tester,
      const HomeScreen(),
      repos: stubRepositories(),
      locale: const Locale.fromSubtags(languageCode: 'es', countryCode: '419'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hola, Ana Pérez'), findsOneWidget);
    expect(find.text('Ganadero'), findsOneWidget);
    expect(find.text('Animales'), findsOneWidget);
    expect(find.text('Requieren atención'), findsOneWidget);
    expect(find.text('Registros sanitarios recientes'), findsOneWidget);
    expect(find.text('Tipo: Sanitario', findRichText: true), findsOneWidget);
    expect(find.text('Alta'), findsOneWidget);
  });

  testWidgets('shows a spinner while the first load is running', (
    tester,
  ) async {
    final repos = stubRepositories();
    when(repos.livestock.fetchHerds).thenAnswer(
      (_) => Future.delayed(const Duration(seconds: 5), () => herds),
    );
    await pumpScreen(tester, const HomeScreen(), repos: repos);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.textContaining('Loading your livestock'), findsOneWidget);

    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Hello, Ana Pérez'), findsOneWidget);
  });

  testWidgets('empty states when the rancher has no data', (tester) async {
    final repos = stubRepositories();
    when(repos.livestock.fetchHerds).thenAnswer((_) async => []);
    when(repos.livestock.fetchAnimals).thenAnswer((_) async => []);
    when(repos.sanitary.fetchEvents).thenAnswer((_) async => []);
    when(repos.activities.fetchActivities).thenAnswer((_) async => []);
    await pumpScreen(tester, const HomeScreen(), repos: repos);
    await tester.pumpAndSettle();

    expect(metricValue('Animals', '0'), findsOneWidget);
    expect(find.text('No upcoming activities.'), findsOneWidget);
    expect(find.text('No health records yet.'), findsOneWidget);
    // No farms, no farm selector.
    expect(find.byType(DropdownMenu<int?>), findsNothing);
  });

  testWidgets('a failed first load shows the error and Retry recovers', (
    tester,
  ) async {
    final repos = stubRepositories();
    when(repos.livestock.fetchHerds)
        .thenThrow(const AppException(NetworkError()));
    await pumpScreen(tester, const HomeScreen(), repos: repos);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Could not reach the server. Check your connection and try again.',
      ),
      findsOneWidget,
    );
    expect(find.text('Hello, Ana Pérez'), findsNothing);

    when(repos.livestock.fetchHerds).thenAnswer((_) async => herds);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Hello, Ana Pérez'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('a failed refresh keeps the data and shows the offline banner', (
    tester,
  ) async {
    final repos = stubRepositories();
    await pumpScreen(tester, const HomeScreen(), repos: repos, height: 900);
    await tester.pumpAndSettle();
    expect(find.textContaining('You are offline'), findsNothing);

    when(repos.sanitary.fetchEvents)
        .thenThrow(const AppException(NetworkError()));
    await pullToRefresh(tester);
    await tester.pumpAndSettle();

    expect(
      find.text('You are offline. Showing the last data loaded.'),
      findsOneWidget,
    );
    expect(metricValue('Animals', '3'), findsOneWidget);

    when(repos.sanitary.fetchEvents).thenAnswer((_) async => events);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.textContaining('You are offline'), findsNothing);
  });

  testWidgets('a non-network refresh failure shows the generic banner', (
    tester,
  ) async {
    final repos = stubRepositories();
    await pumpScreen(tester, const HomeScreen(), repos: repos, height: 900);
    await tester.pumpAndSettle();

    when(repos.activities.fetchActivities)
        .thenThrow(const AppException(ServerError(500)));
    await pullToRefresh(tester);
    await tester.pumpAndSettle();

    expect(
      find.text('Could not refresh. Showing the last data loaded.'),
      findsOneWidget,
    );
  });

  testWidgets('pull to refresh loads the data again', (tester) async {
    final repos = stubRepositories();
    await pumpScreen(tester, const HomeScreen(), repos: repos, height: 900);
    await tester.pumpAndSettle();
    clearInteractions(repos.livestock);

    await pullToRefresh(tester);
    await tester.pumpAndSettle();

    verify(repos.livestock.fetchAnimals).called(1);
  });

  testWidgets('the farm selector narrows the counters to one farm', (
    tester,
  ) async {
    await pumpScreen(tester, const HomeScreen(), repos: stubRepositories());
    await tester.pumpAndSettle();

    // Only the rancher's own farms are offered.
    await tester.tap(find.byType(DropdownMenu<int?>));
    await tester.pumpAndSettle();
    expect(find.text('All farms'), findsWidgets);
    expect(find.text('Los Pinos'), findsOneWidget);
    expect(find.text('El Roble'), findsOneWidget);
    expect(find.text('La Foránea'), findsNothing);

    await tester.tap(find.text('El Roble').last);
    await tester.pumpAndSettle();

    expect(metricValue('Animals', '1'), findsOneWidget);
    expect(metricValue('Need attention', '1'), findsOneWidget);
    expect(metricValue('Health records', '1'), findsOneWidget);
    expect(metricValue('Pending follow-ups', '0'), findsOneWidget);
    expect(find.text('Luna'), findsNothing);
    expect(find.text('Tita'), findsOneWidget);
  });
}
