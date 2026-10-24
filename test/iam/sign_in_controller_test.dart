import 'package:anitec_flutter/core/network/app_error.dart';
import 'package:anitec_flutter/core/session/session_controller.dart';
import 'package:anitec_flutter/iam/iam_providers.dart';
import 'package:anitec_flutter/iam/presentation/sign_in_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../support/fakes.dart';

void main() {
  late MockAuthRepository auth;
  late InMemorySessionStore store;
  late ProviderContainer container;

  setUp(() async {
    auth = MockAuthRepository();
    store = InMemorySessionStore();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        sessionStoreProvider.overrideWithValue(store),
      ],
    );
    addTearDown(container.dispose);
    container.listen(signInControllerProvider, (_, _) {});
    container.read(sessionControllerProvider);
    await Future<void>.delayed(Duration.zero);
  });

  SignInController controller() =>
      container.read(signInControllerProvider.notifier);
  SignInState state() => container.read(signInControllerProvider);

  void fill([String user = 'ana', String password = 'secret']) {
    controller().onUsernameChange(user);
    controller().onPasswordChange(password);
  }

  test('empty fields are flagged and nothing is sent', () async {
    await controller().submit();

    expect(state().usernameMissing, isTrue);
    expect(state().passwordMissing, isTrue);
    verifyNever(() => auth.signIn(any(), any()));
  });

  test('a rancher signs in and the session is kept', () async {
    when(() => auth.signIn('ana', 'secret'))
        .thenAnswer((_) async => rancherSession);
    fill();

    await controller().submit();

    expect(container.read(sessionControllerProvider), isA<SignedIn>());
    expect(store.session, rancherSession);
  });

  test('the username is trimmed before it is sent', () async {
    when(() => auth.signIn('ana', 'secret'))
        .thenAnswer((_) async => rancherSession);
    fill('  ana ');

    await controller().submit();

    verify(() => auth.signIn('ana', 'secret')).called(1);
  });

  test('a veterinarian gets a message and no session is kept', () async {
    when(() => auth.signIn('vet', 'secret'))
        .thenAnswer((_) async => veterinarianSession);
    fill('vet');

    await controller().submit();

    expect(state().failure, isA<VeterinarianNotSupported>());
    expect(state().loading, isFalse);
    expect(container.read(sessionControllerProvider), isA<SignedOut>());
    expect(store.session, isNull);
  });

  test('wrong credentials (400) are reported as such', () async {
    when(() => auth.signIn(any(), any()))
        .thenThrow(const AppException(ValidationError()));
    fill();

    await controller().submit();

    expect(state().failure, isA<InvalidCredentials>());
    expect(container.read(sessionControllerProvider), isA<SignedOut>());
  });

  test('other failures keep their kind', () async {
    when(() => auth.signIn(any(), any()))
        .thenThrow(const AppException(NetworkError()));
    fill();

    await controller().submit();

    final failure = state().failure;
    expect(failure, isA<RequestFailed>());
    expect((failure as RequestFailed).error, isA<NetworkError>());
  });

  test('typing clears the previous failure', () async {
    when(() => auth.signIn(any(), any()))
        .thenThrow(const AppException(ValidationError()));
    fill();
    await controller().submit();

    controller().onPasswordChange('other');

    expect(state().failure, isNull);
  });
}
