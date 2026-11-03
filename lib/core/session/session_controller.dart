// Feature context: authenticated session lifecycle.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'session_store.dart';
import 'user_session.dart';

/// Whether a user is signed in; the router decides the screen from it.
sealed class SessionState {
  const SessionState();
}

/// The stored session is still being read.
final class SessionLoading extends SessionState {
  const SessionLoading();
}

/// Nobody is signed in.
final class SignedOut extends SessionState {
  /// True when a 401 ended the previous session, so the sign-in screen can say why.
  const SignedOut({this.expired = false});

  final bool expired;
}

/// A user is signed in with [session].
final class SignedIn extends SessionState {
  const SignedIn(this.session);

  final UserSession session;
}

/// Secure storage where the session survives app restarts.
final sessionStoreProvider = Provider<SessionStore>(
  (ref) => SecureSessionStore(),
);

/// Session of the app user.
final sessionControllerProvider =
    NotifierProvider<SessionController, SessionState>(SessionController.new);

/// Restores the stored session at start-up and starts or ends it.
class SessionController extends Notifier<SessionState> {
  @override
  SessionState build() {
    Future.microtask(_restore);
    return const SessionLoading();
  }

  /// Token for the HTTP client; null when nobody is signed in.
  String? get token => switch (state) {
    SignedIn(:final session) => session.token,
    _ => null,
  };

  Future<void> _restore() async {
    final session = await ref.read(sessionStoreProvider).read();
    if (state is! SessionLoading) return;
    state = session == null ? const SignedOut() : SignedIn(session);
  }

  /// Saves the session and signs the user in.
  Future<void> start(UserSession session) async {
    await ref.read(sessionStoreProvider).save(session);
    state = SignedIn(session);
  }

  /// Deletes the stored session and signs the user out.
  Future<void> signOut() async {
    await ref.read(sessionStoreProvider).clear();
    state = const SignedOut();
  }

  /// A request with a token got 401: the token expired or was revoked.
  Future<void> onUnauthorized() async {
    if (state is! SignedIn) return;
    await ref.read(sessionStoreProvider).clear();
    state = const SignedOut(expired: true);
  }
}
