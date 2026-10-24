import 'dart:convert';
import 'dart:typed_data';

import 'package:anitec_flutter/activities/domain/activities_repository.dart';
import 'package:anitec_flutter/activities/domain/activity.dart';
import 'package:anitec_flutter/core/session/session_controller.dart';
import 'package:anitec_flutter/core/session/session_store.dart';
import 'package:anitec_flutter/core/session/user_session.dart';
import 'package:anitec_flutter/iam/domain/auth_repository.dart';
import 'package:anitec_flutter/livestock/domain/livestock.dart';
import 'package:anitec_flutter/livestock/domain/livestock_repository.dart';
import 'package:anitec_flutter/sanitary/domain/health_event.dart';
import 'package:anitec_flutter/sanitary/domain/sanitary_repository.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class MockLivestockRepository extends Mock implements LivestockRepository {}

class MockSanitaryRepository extends Mock implements SanitaryRepository {}

class MockActivitiesRepository extends Mock implements ActivitiesRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class InMemorySessionStore implements SessionStore {
  InMemorySessionStore([this.session]);

  UserSession? session;

  @override
  Future<UserSession?> read() async => session;

  @override
  Future<void> save(UserSession value) async => session = value;

  @override
  Future<void> clear() async => session = null;
}

/// Starts already signed in, for screens that only exist behind sign-in.
class SignedInSessionController extends SessionController {
  SignedInSessionController(this.session);

  final UserSession session;

  @override
  SessionState build() => SignedIn(session);
}

/// One recorded request.
class RecordedRequest {
  RecordedRequest(this.method, this.path, this.headers);

  final String method;
  final String path;
  final Map<String, dynamic> headers;
}

/// Answers requests from a table keyed by `"METHOD path"`; anything else is a 404.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.responses);

  /// Value is a `(status, body)` record; `body` is encoded as JSON.
  final Map<String, (int, Object?)> responses;
  final List<RecordedRequest> requests = [];

  /// When set, every request fails as if the device were offline.
  bool offline = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(
      RecordedRequest(options.method, options.path, options.headers),
    );
    if (offline) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
    final (status, body) =
        responses['${options.method} ${options.path}'] ?? (404, null);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const rancherSession = UserSession(
  userId: 7,
  username: 'ana',
  fullName: 'Ana Pérez',
  role: UserRole.rancher,
  token: 'token-ana',
);

const veterinarianSession = UserSession(
  userId: 9,
  username: 'vet',
  fullName: 'Vera Vet',
  role: UserRole.veterinarian,
  token: 'token-vet',
);

/// Today in the fixtures.
final today = DateTime(2026, 10, 23);

/// Ana (id 7) owns herds 1 and 2; herd 3 belongs to somebody else.
const herds = [
  Herd(id: 1, name: 'Los Pinos', ownerId: 7),
  Herd(id: 2, name: 'El Roble', ownerId: 7),
  Herd(id: 3, name: 'La Foránea', ownerId: 99),
];

const animals = [
  Animal(id: 1, name: 'Luna', status: 'Observacion', herdId: 1),
  Animal(id: 2, name: 'Mora', status: 'Saludable', herdId: 1),
  Animal(id: 3, name: 'Tita', status: 'En tratamiento', herdId: 2),
  Animal(id: 4, name: 'Ajena', status: 'En tratamiento', herdId: 3),
];

const events = [
  HealthEvent(
    id: 1,
    animalId: 1,
    type: HealthTypes.incident,
    date: '2026-10-01',
    description: 'Mastitis',
    nextDueDate: '2026-10-30',
  ),
  HealthEvent(
    id: 2,
    animalId: 3,
    type: HealthTypes.vaccine,
    date: '2026-10-10',
    description: 'Aftosa',
  ),
  HealthEvent(
    id: 3,
    animalId: 4,
    type: HealthTypes.checkup,
    date: '2026-10-20',
    description: 'Of a foreign animal',
  ),
];

const activities = [
  Activity(
    id: 1,
    ownerId: 7,
    title: 'Foot-and-mouth vaccination',
    type: ActivityTypes.health,
    date: '2026-10-25',
    priority: ActivityPriorities.high,
    status: ActivityStatuses.scheduled,
  ),
  Activity(
    id: 2,
    ownerId: 7,
    title: 'Done last week',
    type: ActivityTypes.production,
    date: '2026-10-28',
    priority: ActivityPriorities.low,
    status: ActivityStatuses.completed,
  ),
  Activity(
    id: 3,
    ownerId: 7,
    title: 'Forgotten visit',
    type: ActivityTypes.vetVisit,
    date: '2026-10-01',
    priority: ActivityPriorities.medium,
    status: ActivityStatuses.pending,
  ),
  Activity(
    id: 4,
    ownerId: 99,
    title: 'Somebody else task',
    type: ActivityTypes.health,
    date: '2026-10-24',
    priority: ActivityPriorities.high,
    status: ActivityStatuses.pending,
  ),
];

/// A fully stubbed set of repositories returning the fixtures above.
({
  MockLivestockRepository livestock,
  MockSanitaryRepository sanitary,
  MockActivitiesRepository activities,
})
stubRepositories() {
  final livestock = MockLivestockRepository();
  final sanitary = MockSanitaryRepository();
  final activitiesRepo = MockActivitiesRepository();
  when(livestock.fetchHerds).thenAnswer((_) async => herds);
  when(livestock.fetchAnimals).thenAnswer((_) async => animals);
  when(sanitary.fetchEvents).thenAnswer((_) async => events);
  when(activitiesRepo.fetchActivities).thenAnswer((_) async => activities);
  return (livestock: livestock, sanitary: sanitary, activities: activitiesRepo);
}
