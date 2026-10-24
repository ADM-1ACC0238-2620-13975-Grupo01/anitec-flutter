import 'package:anitec_flutter/activities/activities_providers.dart';
import 'package:anitec_flutter/app/home/home_controller.dart';
import 'package:anitec_flutter/core/network/app_error.dart';
import 'package:anitec_flutter/core/session/session_controller.dart';
import 'package:anitec_flutter/livestock/domain/livestock.dart';
import 'package:anitec_flutter/livestock/livestock_providers.dart';
import 'package:anitec_flutter/sanitary/sanitary_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../support/fakes.dart';

void main() {
  late ({
    MockLivestockRepository livestock,
    MockSanitaryRepository sanitary,
    MockActivitiesRepository activities,
  })
  repos;
  late ProviderContainer container;

  setUp(() {
    repos = stubRepositories();
    container = ProviderContainer(
      overrides: [
        sessionControllerProvider.overrideWith(
          () => SignedInSessionController(rancherSession),
        ),
        livestockRepositoryProvider.overrideWithValue(repos.livestock),
        sanitaryRepositoryProvider.overrideWithValue(repos.sanitary),
        activitiesRepositoryProvider.overrideWithValue(repos.activities),
        clockProvider.overrideWithValue(() => today),
      ],
    );
    addTearDown(container.dispose);
  });

  /// Keeps the dashboard alive, which also starts its first load.
  void open() => container.listen(homeControllerProvider, (_, _) {});

  HomeState state() => container.read(homeControllerProvider);
  HomeController controller() =>
      container.read(homeControllerProvider.notifier);

  Future<void> loaded() => Future<void>.delayed(Duration.zero);

  test('starts loading and then shows the rancher\'s data', () async {
    open();
    expect(state().refreshing, isTrue);
    expect(state().data, isNull);

    await loaded();

    expect(state().refreshing, isFalse);
    expect(state().error, isNull);
    final summary = state().summary!;
    expect(summary.animalCount, 3);
    expect(summary.recordCount, 2);
    expect(summary.upcomingCount, 1);
    expect(state().data!.today, today);
  });

  test(
    'selecting a farm narrows the summary and null goes back to all',
    () async {
      open();
      await loaded();

      controller().onHerdSelected(2);
      expect(state().summary!.animalCount, 1);
      expect(state().summary!.attentionCount, 1);

      controller().onHerdSelected(null);
      expect(state().summary!.animalCount, 3);
    },
  );

  test('a failed first load leaves no data and keeps the error', () async {
    when(repos.livestock.fetchHerds)
        .thenThrow(const AppException(NetworkError()));
    open();

    await loaded();

    expect(state().data, isNull);
    expect(state().error, isA<NetworkError>());
    expect(state().refreshing, isFalse);
  });

  test(
    'a failed refresh keeps the data on screen and clears on success',
    () async {
      open();
      await loaded();
      when(repos.sanitary.fetchEvents)
          .thenThrow(const AppException(ServerError(500)));

      await controller().refresh();

      expect(state().error, isA<ServerError>());
      expect(state().summary!.animalCount, 3);

      when(repos.sanitary.fetchEvents).thenAnswer((_) async => events);
      await controller().refresh();

      expect(state().error, isNull);
    },
  );

  test('refresh picks up new data', () async {
    open();
    await loaded();
    when(repos.livestock.fetchAnimals).thenAnswer(
      (_) async => [
        ...animals,
        const Animal(id: 10, name: 'Nueva', status: 'Saludable', herdId: 1),
      ],
    );

    await controller().refresh();

    expect(state().summary!.animalCount, 4);
  });

  test(
    'refresh calls every endpoint once and ignores overlapping calls',
    () async {
      open();
      await loaded();
      var calls = 0;
      when(repos.livestock.fetchHerds).thenAnswer((_) async {
        calls++;
        return herds;
      });

      await Future.wait([controller().refresh(), controller().refresh()]);

      expect(calls, 1);
    },
  );
}
