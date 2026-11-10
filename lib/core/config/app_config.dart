import 'package:flutter/foundation.dart';

/// Build-time configuration.
///
/// The emulator reaches the host machine at `10.0.2.2`. Override the URL with
/// `--dart-define=API_BASE_URL=...` to test against a physical device or another server.
abstract final class AppConfig {
  /// Local backend as seen from the Android emulator.
  static const String debugBaseUrl = 'http://10.0.2.2:5191/api/v1/';
  /// Backend hosted on Render, used by release builds.
  static const String releaseBaseUrl =
      'https://anitec-backend-android.onrender.com/api/v1/';

  static const String _override = String.fromEnvironment('API_BASE_URL');

  /// URL every request uses: the `API_BASE_URL` define when given, otherwise the one for the build mode.
  static String get apiBaseUrl {
    if (_override.isNotEmpty) return _override;
    return kReleaseMode ? releaseBaseUrl : debugBaseUrl;
  }
}
