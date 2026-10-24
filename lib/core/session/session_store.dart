import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'user_session.dart';

/// Persists the signed-in session across launches.
abstract interface class SessionStore {
  Future<UserSession?> read();

  Future<void> save(UserSession session);

  Future<void> clear();
}

/// Keeps the session, token included, in the platform keystore.
class SecureSessionStore implements SessionStore {
  SecureSessionStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'session';

  final FlutterSecureStorage _storage;

  @override
  Future<UserSession?> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null) return null;
      return UserSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // A corrupted or unreadable entry is the same as no session.
      await clear();
      return null;
    }
  }

  @override
  Future<void> save(UserSession session) =>
      _storage.write(key: _key, value: jsonEncode(session.toJson()));

  @override
  Future<void> clear() async {
    try {
      await _storage.delete(key: _key);
    } catch (_) {
      // Nothing to clear if the keystore is unavailable.
    }
  }
}
