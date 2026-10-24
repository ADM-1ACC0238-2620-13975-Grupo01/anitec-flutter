import 'package:flutter/material.dart';

import 'colors.dart';

/// Semantic severity of a status tag, equivalent to PrimeVue's Tag severities.
enum Severity { success, warn, info, danger, neutral }

class StatusPalette {
  const StatusPalette(this.container, this.content);

  final Color container;
  final Color content;
}

/// Material 3 has no success/warn/info roles, so the web tag colors live here.
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors();

  static const _success = StatusPalette(Color(0xFFE4F2DE), Color(0xFF386B2C));
  static const _warn = StatusPalette(Color(0xFFFBEBD0), Color(0xFF92600B));
  static const _info = StatusPalette(Color(0xFFE1EEF7), Color(0xFF1F5C86));
  static const _danger = StatusPalette(Color(0xFFF8E1DE), Color(0xFFA23B2E));
  static const _neutral = StatusPalette(
    AniTecColors.sand,
    AniTecColors.brownDark,
  );

  StatusPalette of(Severity severity) => switch (severity) {
    Severity.success => _success,
    Severity.warn => _warn,
    Severity.info => _info,
    Severity.danger => _danger,
    Severity.neutral => _neutral,
  };

  @override
  StatusColors copyWith() => this;

  @override
  StatusColors lerp(StatusColors? other, double t) => this;
}

extension StatusColorsTheme on ThemeData {
  StatusColors get statusColors =>
      extension<StatusColors>() ?? const StatusColors();
}
