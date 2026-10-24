import 'package:flutter/material.dart';

/// Type scale of the native app (`core/designsystem/Type.kt`). The system font is used, as on Android.
/// Compose line heights are in sp; Flutter wants a multiple of the font size.
TextStyle _style(
  double size,
  FontWeight weight,
  double lineHeight, {
  double letterSpacing = 0,
}) => TextStyle(
  fontSize: size,
  fontWeight: weight,
  height: lineHeight / size,
  letterSpacing: letterSpacing,
);

final TextTheme aniTecTextTheme = TextTheme(
  displayMedium: _style(38, FontWeight.w800, 40),
  headlineMedium: _style(28, FontWeight.w700, 34),
  headlineSmall: _style(24, FontWeight.w700, 30),
  titleLarge: _style(22, FontWeight.w700, 28),
  titleMedium: _style(19, FontWeight.w700, 25),
  titleSmall: _style(17, FontWeight.w700, 23),
  bodyLarge: _style(16, FontWeight.w400, 24),
  bodyMedium: _style(15, FontWeight.w400, 22),
  bodySmall: _style(13, FontWeight.w400, 19),
  labelLarge: _style(15, FontWeight.w700, 20),
  labelMedium: _style(13, FontWeight.w800, 18),
  labelSmall: _style(12, FontWeight.w800, 16, letterSpacing: 12 * 0.08),
);
