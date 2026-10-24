import 'package:anitec_flutter/core/session/session_controller.dart';
import 'package:anitec_flutter/core/session/user_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart';

ProviderContainer containerWith(InMemorySessionStore store) {
  final container = ProviderContainer(
    overrides: [sessionStoreProvider.overrideWithValue(store)],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  test('is loading until the stored session is read', () async {
    final container = containerWith(InMemorySessionStore());
    expect(container.read(sessionControllerProvider), isA<SessionLoading>());
    await settle();
    expect(container.read(sessionControllerProvider), isA<SignedOut>());
  });

  test('restores a stored session', () async {
    final container = containerWith(InMemorySessionStore(rancherSession));
    container.read(sessionControllerProvider);
    await settle();
    final state = container.read(sessionControllerProvider);
    expect(state, isA<SignedIn>());
    expect((state as SignedIn).session.userId, 7);
    expect(
      container.read(sessionControllerProvider.notifier).token,
      'token-ana',
    );
  });

  test('start persists the session and signs in', () async {
    final store = InMemorySessionStore();
    final container = containerWith(store);
    container.read(sessionControllerProvider);
    await settle();

    await container
        .read(sessionControllerProvider.notifier)
        .start(rancherSession);

    expect(container.read(sessionControllerProvider), isA<SignedIn>());
    expect(store.session, rancherSession);
  });

  test('signOut clears the stored session and the token', () async {
    final store = InMemorySessionStore(rancherSession);
    final container = containerWith(store);
    container.read(sessionControllerProvider);
    await settle();

    final controller = container.read(sessionControllerProvider.notifier);
    await controller.signOut();

    final state = container.read(sessionControllerProvider);
    expect(state, isA<SignedOut>());
    expect((state as SignedOut).expired, isFalse);
    expect(store.session, isNull);
    expect(controller.token, isNull);
  });

  test('a 401 signs out and flags the session as expired', () async {
    final store = InMemorySessionStore(rancherSession);
    final container = containerWith(store);
    container.read(sessionControllerProvider);
    await settle();

    await container.read(sessionControllerProvider.notifier).onUnauthorized();

    final state = container.read(sessionControllerProvider);
    expect(state, isA<SignedOut>());
    expect((state as SignedOut).expired, isTrue);
    expect(store.session, isNull);
  });

  test('a 401 while signed out changes nothing', () async {
    final container = containerWith(InMemorySessionStore());
    container.read(sessionControllerProvider);
    await settle();

    await container.read(sessionControllerProvider.notifier).onUnauthorized();

    expect(
      (container.read(sessionControllerProvider) as SignedOut).expired,
      isFalse,
    );
  });

  test('the session round-trips through JSON', () {
    final copy = UserSession.fromJson(rancherSession.toJson());
    expect(copy.userId, rancherSession.userId);
    expect(copy.role, UserRole.rancher);
    expect(copy.token, rancherSession.token);
  });
}
