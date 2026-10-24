import 'package:flutter/foundation.dart';

/// Build-time configuration.
///
/// The emulator reaches the host machine at `10.0.2.2`. Override the URL with
/// `--dart-define=API_BASE_URL=...` to test against a physical device or another server.
abstract final class AppConfig {
  static const String debugBaseUrl = 'http://10.0.2.2:5191/api/v1/';
  static const String releaseBaseUrl =
      'https://anitec-backend-android.onrender.com/api/v1/';

  static const String _override = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_override.isNotEmpty) return _override;
    return kReleaseMode ? releaseBaseUrl : debugBaseUrl;
  }
}
