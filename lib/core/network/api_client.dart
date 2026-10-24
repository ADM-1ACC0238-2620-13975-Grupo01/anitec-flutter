import 'package:dio/dio.dart';

/// Builds the [Dio] used by every API repository.
///
/// Attaches `Authorization: Bearer <token>` when a token exists. A 401 on a request that carried a
/// token calls [onUnauthorized] so the app signs the user out: tokens last 7 days and cannot be
/// refreshed. A 401 without a token (a failed sign-in) is left alone.
///
/// Timeouts are 60 s because the hosted backend (Render free tier) can take about a minute to wake up.
Dio createApiClient({
  required String baseUrl,
  required String? Function() readToken,
  required void Function() onUnauthorized,
  HttpClientAdapter? adapter,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    ),
  );
  if (adapter != null) dio.httpClientAdapter = adapter;
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = readToken();
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (error, handler) {
        final sentToken = error.requestOptions.headers.containsKey(
          'Authorization',
        );
        if (error.response?.statusCode == 401 && sentToken) onUnauthorized();
        handler.next(error);
      },
    ),
  );
  return dio;
}
