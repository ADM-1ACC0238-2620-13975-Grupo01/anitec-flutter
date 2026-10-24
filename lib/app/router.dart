import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/session/session_controller.dart';
import '../iam/presentation/sign_in_screen.dart';
import '../iam/presentation/terms_screen.dart';
import 'home/home_screen.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const signIn = '/sign-in';
  static const terms = '/terms';
  static const home = '/home';
}

/// Sends the user to the right screen for the session: nothing is shown until the stored session is
/// read, signed-out users only reach sign-in and the terms, signed-in users never see sign-in.
String? redirectFor(SessionState session, String location) => switch (session) {
  SessionLoading() => location == Routes.splash ? null : Routes.splash,
  SignedOut() =>
    location == Routes.signIn || location == Routes.terms
        ? null
        : Routes.signIn,
  SignedIn() =>
    location == Routes.signIn || location == Routes.splash ? Routes.home : null,
};

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(sessionControllerProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);
  final router = GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) =>
        redirectFor(ref.read(sessionControllerProvider), state.matchedLocation),
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: Routes.terms,
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
