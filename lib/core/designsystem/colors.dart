import 'package:flutter/painting.dart';

/// Brand tokens, shared with the native Android app (`core/designsystem/Color.kt`).
abstract final class AniTecColors {
  /// Brand greens; [greenDark] is the primary color of the theme.
  static const green = Color(0xFF79B267);
  static const greenDark = Color(0xFF4F8F45);
  /// Secondary browns, used for accents and containers.
  static const brown = Color(0xFF925930);
  static const brownDark = Color(0xFF6F3F22);
  /// Page background, behind panels.
  static const cream = Color(0xFFF5F0E6);
  static const panel = Color(0xFFFFFAF2);
  static const sand = Color(0xFFD1BFA5);
  /// Main text color; [muted] is for secondary text and [line] for borders.
  static const ink = Color(0xFF1E2520);
  static const muted = Color(0xFF657069);
  static const line = Color(0xFFE7DFD1);
  static const error = Color(0xFFB42318);
}
