import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/designsystem/components.dart';
import '../../core/i18n/error_messages.dart';
import '../../core/i18n/language_menu.dart';
import '../../core/session/session_controller.dart';
import '../../l10n/app_localizations.dart';
import 'sign_in_controller.dart';

/// Sign-in screen for ranchers, with the language menu. It tells the user when the previous
/// session expired and when a veterinarian account tries to sign in.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}
/// State class for [SignInScreen] managing local UI state such as password visibility.
class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _passwordVisible = false;
  /// Builds the sign-in screen UI, initializing localization, theme data,
  /// controller states, session expiration checks, and validation error messages.
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(signInControllerProvider);
    final controller = ref.read(signInControllerProvider.notifier);
    final expired = switch (ref.watch(sessionControllerProvider)) {
      SignedOut(:final expired) => expired,
      _ => false,
    };
    final required = l10n.errorFieldRequired;

    return Scaffold(
      appBar: AppBar(actions: const [LanguageMenu()]),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 14,
                children: [
                  SectionChip(l10n.authHeroChip),
                  Text(
                    l10n.authHeroTitle,
                    style: theme.textTheme.headlineMedium,
                  ),
                  Text(
                    l10n.authHeroSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AniTecPanel(
                    padding: const EdgeInsets.all(20),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 14,
                        children: [
                          Text(
                            l10n.authSignInTitle,
                            style: theme.textTheme.titleLarge,
                          ),
                          Text(
                            l10n.authSignInSubtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (expired) ErrorMessage(l10n.errorSessionExpired),
                          TextField(
                            key: const Key('username'),
                            onChanged: controller.onUsernameChange,
                            enabled: !state.loading,
                            autofillHints: const [AutofillHints.username],
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: l10n.authUsername,
                              errorText: state.usernameMissing
                                  ? required
                                  : null,
                            ),
                          ),
                          TextField(
                            key: const Key('password'),
                            onChanged: controller.onPasswordChange,
                            enabled: !state.loading,
                            obscureText: !_passwordVisible,
                            autofillHints: const [AutofillHints.password],
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => controller.submit(),
                            decoration: InputDecoration(
                              labelText: l10n.authPassword,
                              errorText: state.passwordMissing
                                  ? required
                                  : null,
                              suffixIcon: IconButton(
                                tooltip: _passwordVisible
                                    ? l10n.commonHidePassword
                                    : l10n.commonShowPassword,
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () => setState(
                                  () => _passwordVisible = !_passwordVisible,
                                ),
                              ),
                            ),
                          ),
                          if (state.failure != null)
                            ErrorMessage(_failureMessage(l10n, state.failure!)),
                          FilledButton.icon(
                            onPressed: state.loading ? null : controller.submit,
                            icon: state.loading
                                ? const SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.login),
                            label: Text(l10n.authSignInAction),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/terms'),
                    child: Text(l10n.authReadTerms),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _failureMessage(AppLocalizations l10n, SignInFailure failure) =>
      switch (failure) {
        InvalidCredentials() => l10n.authInvalidCredentials,
        VeterinarianNotSupported() => l10n.authVeterinarianNotSupported,
        RequestFailed(:final error) => appErrorMessage(l10n, error),
      };
}
