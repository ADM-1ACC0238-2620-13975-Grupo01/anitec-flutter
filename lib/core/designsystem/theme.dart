import 'package:flutter/material.dart';

import 'colors.dart';
import 'status_colors.dart';
import 'typography.dart';

/// Corner radius of panels, buttons and fields (8 dp, as on Android).
const double aniTecRadius = 8;

// The web app has no dark mode, so the app ships a single light scheme.
const _colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AniTecColors.greenDark,
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFE4F2DE),
  onPrimaryContainer: Color(0xFF386B2C),
  secondary: AniTecColors.brown,
  onSecondary: Colors.white,
  secondaryContainer: AniTecColors.sand,
  onSecondaryContainer: AniTecColors.brownDark,
  tertiary: AniTecColors.brownDark,
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFFBEBD0),
  onTertiaryContainer: Color(0xFF92600B),
  error: AniTecColors.error,
  onError: Colors.white,
  errorContainer: Color(0xFFF8E1DE),
  onErrorContainer: Color(0xFFA23B2E),
  surface: AniTecColors.panel,
  onSurface: AniTecColors.ink,
  onSurfaceVariant: AniTecColors.muted,
  outline: AniTecColors.muted,
  outlineVariant: AniTecColors.line,
  surfaceContainerLowest: Colors.white,
  surfaceContainerLow: Color(0xFFFFFDF8),
  surfaceContainer: AniTecColors.panel,
  surfaceContainerHigh: Color(0xFFF7EFE2),
  surfaceContainerHighest: Color(0xFFF0E6D2),
  scrim: AniTecColors.ink,
);

ThemeData buildAniTecTheme() {
  const shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(aniTecRadius)),
  );
  const fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(aniTecRadius)),
    borderSide: BorderSide(color: AniTecColors.line),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    textTheme: aniTecTextTheme,
    scaffoldBackgroundColor: AniTecColors.cream,
    extensions: const [StatusColors()],
    appBarTheme: const AppBarTheme(
      backgroundColor: AniTecColors.cream,
      foregroundColor: AniTecColors.ink,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: AniTecColors.panel,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: shape,
        minimumSize: const Size.fromHeight(48),
        textStyle: aniTecTextTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: shape,
        foregroundColor: AniTecColors.greenDark,
        textStyle: aniTecTextTheme.labelLarge,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AniTecColors.panel,
      border: fieldBorder,
      enabledBorder: fieldBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(aniTecRadius)),
        borderSide: BorderSide(color: AniTecColors.greenDark, width: 2),
      ),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AniTecColors.panel,
        border: fieldBorder,
        enabledBorder: fieldBorder,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: shape,
    ),
  );
}
