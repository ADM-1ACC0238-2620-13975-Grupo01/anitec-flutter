import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../session/session_controller.dart';
import 'api_client.dart';

/// HTTP client of the AniTec API. It sends the current session token and ends the session
/// when the server answers 401.
final dioProvider = Provider<Dio>((ref) {
  final session = ref.read(sessionControllerProvider.notifier);
  return createApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    readToken: () => session.token,
    onUnauthorized: session.onUnauthorized,
  );
});
