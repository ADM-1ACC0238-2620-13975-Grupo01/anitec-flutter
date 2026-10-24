import 'dart:typed_data';

import 'package:anitec_flutter/core/network/api_client.dart';
import 'package:anitec_flutter/core/network/app_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart';

void main() {
  late FakeAdapter adapter;
  late int unauthorizedCalls;
  String? token;

  Dio build() => createApiClient(
    baseUrl: 'http://localhost/api/v1/',
    readToken: () => token,
    onUnauthorized: () => unauthorizedCalls++,
    adapter: adapter,
  );

  setUp(() {
    adapter = FakeAdapter({});
    unauthorizedCalls = 0;
    token = null;
  });

  test('sends the Bearer token when there is a session', () async {
    adapter.responses['GET herds'] = (200, <Object>[]);
    token = 'abc';
    await build().get<Object?>('herds');
    expect(adapter.requests.single.headers['Authorization'], 'Bearer abc');
  });

  test('sends no Authorization header without a session', () async {
    adapter.responses['GET herds'] = (200, <Object>[]);
    await build().get<Object?>('herds');
    expect(
      adapter.requests.single.headers.containsKey('Authorization'),
      isFalse,
    );
  });

  test('a 401 with a token reports the session as unauthorized', () async {
    adapter.responses['GET herds'] = (401, null);
    token = 'expired';
    await expectLater(
      guardApi(() => build().get<Object?>('herds')),
      throwsA(
        isA<AppException>().having(
          (e) => e.error,
          'error',
          isA<UnauthorizedError>(),
        ),
      ),
    );
    expect(unauthorizedCalls, 1);
  });

  test('a late 401 from an old session does not end the new one', () async {
    final swapping = _TokenSwappingAdapter(() => token = 'new-session');
    swapping.responses['GET herds'] = (401, null);
    token = 'old-session';
    final dio = createApiClient(
      baseUrl: 'http://localhost/api/v1/',
      readToken: () => token,
      onUnauthorized: () => unauthorizedCalls++,
      adapter: swapping,
    );

    await expectLater(
      guardApi(() => dio.get<Object?>('herds')),
      throwsA(isA<AppException>()),
    );

    expect(unauthorizedCalls, 0);
  });

  test(
    'a 401 without a token (failed sign-in) does not end any session',
    () async {
      adapter.responses['POST authentication/sign-in'] = (401, null);
      await expectLater(
        guardApi(() => build().post<Object?>('authentication/sign-in')),
        throwsA(isA<AppException>()),
      );
      expect(unauthorizedCalls, 0);
    },
  );

  group('guardApi maps failures to AppError', () {
    Future<AppError> errorOf(int status) async {
      adapter.responses['GET x'] = (status, null);
      try {
        await guardApi(() => build().get<Object?>('x'));
      } on AppException catch (e) {
        return e.error;
      }
      throw StateError('expected a failure');
    }

    test('by HTTP status', () async {
      expect(await errorOf(400), isA<ValidationError>());
      expect(await errorOf(403), isA<ForbiddenError>());
      expect(await errorOf(404), isA<NotFoundError>());
      expect(await errorOf(409), isA<ConflictError>());
      expect(await errorOf(500), isA<ServerError>());
      expect(await errorOf(503), isA<ServerError>());
      expect(await errorOf(418), isA<UnknownError>());
    });

    test('no connection is a NetworkError', () async {
      adapter.offline = true;
      await expectLater(
        guardApi(() => build().get<Object?>('x')),
        throwsA(
          isA<AppException>().having(
            (e) => e.error,
            'error',
            isA<NetworkError>(),
          ),
        ),
      );
    });

    test('malformed data is an UnknownError, not a crash', () async {
      await expectLater(
        guardApi(() async => throw const FormatException('bad')),
        throwsA(
          isA<AppException>().having(
            (e) => e.error,
            'error',
            isA<UnknownError>(),
          ),
        ),
      );
    });
  });
}

/// Signs in again while the request is in flight, as happens when the user switches accounts quickly.
class _TokenSwappingAdapter extends FakeAdapter {
  _TokenSwappingAdapter(this._signInAgain) : super({});

  final void Function() _signInAgain;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    _signInAgain();
    return super.fetch(options, requestStream, cancelFuture);
  }
}
