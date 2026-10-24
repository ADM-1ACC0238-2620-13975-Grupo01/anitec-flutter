import 'package:anitec_flutter/app/router.dart';
import 'package:anitec_flutter/core/session/session_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart';

void main() {
  group('redirectFor', () {
    test('while the session loads everything waits on the splash', () {
      const state = SessionLoading();
      expect(redirectFor(state, Routes.home), Routes.splash);
      expect(redirectFor(state, Routes.signIn), Routes.splash);
      expect(redirectFor(state, Routes.splash), isNull);
    });

    test('signed-out users only reach sign-in and the terms', () {
      const state = SignedOut();
      expect(redirectFor(state, Routes.home), Routes.signIn);
      expect(redirectFor(state, Routes.splash), Routes.signIn);
      expect(redirectFor(state, Routes.signIn), isNull);
      expect(redirectFor(state, Routes.terms), isNull);
    });

    test('signed-in users go home and never see sign-in', () {
      final state = SignedIn(rancherSession);
      expect(redirectFor(state, Routes.signIn), Routes.home);
      expect(redirectFor(state, Routes.splash), Routes.home);
      expect(redirectFor(state, Routes.home), isNull);
      expect(redirectFor(state, Routes.terms), isNull);
    });
  });
}
