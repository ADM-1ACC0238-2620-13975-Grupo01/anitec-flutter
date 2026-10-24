import '../../core/session/user_session.dart';

abstract interface class AuthRepository {
  /// Signs in with `authentication/sign-in`. Nothing is persisted here: the caller decides whether the
  /// session may be used. Failures surface as `AppException`; wrong credentials are a `ValidationError`.
  Future<UserSession> signIn(String username, String password);
}
