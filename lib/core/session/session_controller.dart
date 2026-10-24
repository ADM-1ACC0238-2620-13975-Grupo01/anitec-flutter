import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'session_store.dart';
import 'user_session.dart';

sealed class SessionState {
  const SessionState();
}

/// The stored session is still being read.
final class SessionLoading extends SessionState {
  const SessionLoading();
}

final class SignedOut extends SessionState {
  /// True when a 401 ended the previous session, so the sign-in screen can say why.
  const SignedOut({this.expired = false});

  final bool expired;
}

final class SignedIn extends SessionState {
  const SignedIn(this.session);

  final UserSession session;
}

final sessionStoreProvider = Provider<SessionStore>(
  (ref) => SecureSessionStore(),
);

final sessionControllerProvider =
    NotifierProvider<SessionController, SessionState>(SessionController.new);

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

  Future<void> start(UserSession session) async {
    await ref.read(sessionStoreProvider).save(session);
    state = SignedIn(session);
  }

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
