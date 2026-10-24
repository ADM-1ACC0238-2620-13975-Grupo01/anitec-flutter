import 'package:anitec_flutter/activities/data/activities_repository_impl.dart';
import 'package:anitec_flutter/core/network/api_client.dart';
import 'package:anitec_flutter/core/network/app_error.dart';
import 'package:anitec_flutter/core/session/user_session.dart';
import 'package:anitec_flutter/iam/data/auth_repository_impl.dart';
import 'package:anitec_flutter/livestock/data/livestock_repository_impl.dart';
import 'package:anitec_flutter/sanitary/data/sanitary_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart';

void main() {
  late FakeAdapter adapter;
  late Dio dio;

  setUp(() {
    adapter = FakeAdapter({});
    dio = createApiClient(
      baseUrl: 'http://localhost/api/v1/',
      readToken: () => 'token',
      onUnauthorized: () {},
      adapter: adapter,
    );
  });

  test('livestock reads herds and animals', () async {
    adapter.responses['GET herds'] = (
      200,
      [
        {
          'id': 1,
          'name': 'Los Pinos',
          'location': 'Cusco',
          'owner': 'Ana',
          'ownerId': 7,
          'veterinarianId': null,
          'mainType': 'Bovino',
        },
      ],
    );
    adapter.responses['GET animals'] = (
      200,
      [
        {
          'id': 5,
          'tag': 'A-005',
          'name': 'Luna',
          'species': 'Bovino',
          'breed': 'Holstein',
          'gender': 'Hembra',
          'birthDate': null,
          'weight': 410.5,
          'status': 'Observacion',
          'herdId': 1,
          'corralId': null,
        },
      ],
    );
    final repository = LivestockRepositoryImpl(dio);

    final herds = await repository.fetchHerds();
    final animals = await repository.fetchAnimals();

    expect(herds.single.name, 'Los Pinos');
    expect(herds.single.ownerId, 7);
    expect(animals.single.name, 'Luna');
    expect(animals.single.herdId, 1);
    expect(animals.single.healthStatus.needsAttention, isTrue);
  });

  test('sanitary reads health events, with optional fields missing', () async {
    adapter.responses['GET health-events'] = (
      200,
      [
        {'id': 1, 'animalId': 5, 'type': 'Vacuna', 'date': '2026-10-10'},
        {
          'id': 2,
          'animalId': 5,
          'type': 'Incidencia',
          'date': '2026-10-11',
          'description': 'Cojera',
          'nextDueDate': '2026-10-20',
        },
      ],
    );

    final events = await SanitaryRepositoryImpl(dio).fetchEvents();

    expect(events.first.description, '');
    expect(events.first.hasFollowUp, isFalse);
    expect(events.last.description, 'Cojera');
    expect(events.last.hasFollowUp, isTrue);
  });

  test('activities come from the farm-events route', () async {
    adapter.responses['GET farm-events'] = (
      200,
      [
        {
          'id': 3,
          'ownerId': 7,
          'veterinarianId': null,
          'title': 'Vaccination',
          'type': 'Sanitario',
          'date': '2026-10-25',
          'priority': 'Alta',
          'status': 'Pendiente',
        },
        {'id': 4, 'title': 'No owner', 'date': '2026-10-26'},
      ],
    );

    final activities = await ActivitiesRepositoryImpl(dio).fetchActivities();

    expect(activities.first.ownerId, 7);
    expect(activities.first.priority, 'Alta');
    expect(activities.last.ownerId, isNull);
    expect(adapter.requests.single.path, 'farm-events');
  });

  test('a failing request is an AppException', () async {
    adapter.responses['GET herds'] = (500, null);
    await expectLater(
      LivestockRepositoryImpl(dio).fetchHerds(),
      throwsA(
        isA<AppException>().having((e) => e.error, 'error', isA<ServerError>()),
      ),
    );
  });

  group('sign-in', () {
    test('returns the session of the API user', () async {
      adapter.responses['POST authentication/sign-in'] = (
        200,
        {
          'id': 7,
          'username': 'ana',
          'fullName': 'Ana Pérez',
          'role': 'Rancher',
          'token': 'jwt',
          'email': 'ana@example.com',
        },
      );

      final session = await AuthRepositoryImpl(dio).signIn('ana', 'secret');

      expect(session.userId, 7);
      expect(session.fullName, 'Ana Pérez');
      expect(session.role, UserRole.rancher);
      expect(session.token, 'jwt');
      expect(session.email, 'ana@example.com');
    });

    test('uses the username when the full name is blank', () async {
      adapter.responses['POST authentication/sign-in'] = (
        200,
        {
          'id': 7,
          'username': 'ana',
          'fullName': '',
          'role': 'rancher',
          'token': 'jwt',
        },
      );
      final session = await AuthRepositoryImpl(dio).signIn('ana', 'secret');
      expect(session.fullName, 'ana');
      expect(session.role, UserRole.rancher);
    });

    test('an unknown role is rejected', () async {
      adapter.responses['POST authentication/sign-in'] = (
        200,
        {'id': 7, 'username': 'x', 'role': 'Admin', 'token': 'jwt'},
      );
      await expectLater(
        AuthRepositoryImpl(dio).signIn('x', 'y'),
        throwsA(
          isA<AppException>().having(
            (e) => e.error,
            'error',
            isA<UnknownError>(),
          ),
        ),
      );
    });

    test('wrong credentials (400) are a ValidationError', () async {
      adapter.responses['POST authentication/sign-in'] = (
        400,
        {'message': 'bad'},
      );
      await expectLater(
        AuthRepositoryImpl(dio).signIn('ana', 'wrong'),
        throwsA(
          isA<AppException>().having(
            (e) => e.error,
            'error',
            isA<ValidationError>(),
          ),
        ),
      );
    });
  });
}
