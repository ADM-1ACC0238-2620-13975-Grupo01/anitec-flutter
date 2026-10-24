import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/app_error.dart';
import '../../core/session/session_controller.dart';
import '../../core/session/user_session.dart';
import '../iam_providers.dart';

sealed class SignInFailure {
  const SignInFailure();
}

final class InvalidCredentials extends SignInFailure {
  const InvalidCredentials();
}

/// The account is a veterinarian: this app only serves ranchers, so no session is kept.
final class VeterinarianNotSupported extends SignInFailure {
  const VeterinarianNotSupported();
}

final class RequestFailed extends SignInFailure {
  const RequestFailed(this.error);

  final AppError error;
}

class SignInState {
  const SignInState({
    this.username = '',
    this.password = '',
    this.showFieldErrors = false,
    this.loading = false,
    this.failure,
  });

  final String username;
  final String password;
  final bool showFieldErrors;
  final bool loading;
  final SignInFailure? failure;

  bool get usernameMissing => showFieldErrors && username.trim().isEmpty;
  bool get passwordMissing => showFieldErrors && password.isEmpty;

  SignInState copyWith({
    String? username,
    String? password,
    bool? showFieldErrors,
    bool? loading,
    SignInFailure? failure,
    bool clearFailure = false,
  }) => SignInState(
    username: username ?? this.username,
    password: password ?? this.password,
    showFieldErrors: showFieldErrors ?? this.showFieldErrors,
    loading: loading ?? this.loading,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}

final signInControllerProvider =
    NotifierProvider.autoDispose<SignInController, SignInState>(
      SignInController.new,
    );

class SignInController extends Notifier<SignInState> {
  @override
  SignInState build() => const SignInState();

  void onUsernameChange(String value) =>
      state = state.copyWith(username: value, clearFailure: true);

  void onPasswordChange(String value) =>
      state = state.copyWith(password: value, clearFailure: true);

  Future<void> submit() async {
    final current = state;
    if (current.loading) return;
    if (current.username.trim().isEmpty || current.password.isEmpty) {
      state = current.copyWith(showFieldErrors: true);
      return;
    }
    state = current.copyWith(loading: true, clearFailure: true);
    try {
      final session = await ref
          .read(authRepositoryProvider)
          .signIn(current.username.trim(), current.password);
      if (!ref.mounted) return;
      if (session.role != UserRole.rancher) {
        state = state.copyWith(
          loading: false,
          failure: const VeterinarianNotSupported(),
        );
        return;
      }
      // The router leaves this screen as soon as the session starts.
      await ref.read(sessionControllerProvider.notifier).start(session);
      if (ref.mounted) state = state.copyWith(loading: false);
    } on AppException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(loading: false, failure: _failureFor(e.error));
    }
  }

  /// The API answers wrong credentials with 400, not 401.
  SignInFailure _failureFor(AppError error) => switch (error) {
    ValidationError() => const InvalidCredentials(),
    _ => RequestFailed(error),
  };
}
