import 'package:flutter/material.dart';

import 'status_colors.dart';
import 'theme.dart';

/// Card surface with a thin border, the web's `.panel`.
class AniTecPanel extends StatelessWidget {
  const AniTecPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(aniTecRadius),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Uppercase eyebrow used above titles, e.g. "LIVESTOCK MANAGEMENT".
class SectionChip extends StatelessWidget {
  const SectionChip(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.primary,
      ),
    );
  }
}

/// Colored status label. The text always carries the meaning, not only the color.
class StatusTag extends StatelessWidget {
  const StatusTag(this.text, this.severity, {super.key});

  final String text;
  final Severity severity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.statusColors.of(severity);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.container,
        borderRadius: BorderRadius.circular(aniTecRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: theme.textTheme.labelMedium?.copyWith(color: palette.content),
        ),
      ),
    );
  }
}

/// Counter card: icon, label, value and an optional caption.
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.caption,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? caption;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return AniTecPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.primary),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: muted)),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: valueColor ?? theme.colorScheme.tertiary,
            ),
          ),
          if (caption != null)
            Text(
              caption!,
              style: theme.textTheme.bodySmall?.copyWith(color: muted),
            ),
        ],
      ),
    );
  }
}

/// Card of one record: title, kicker line, a trailing tag and label/value details.
class RecordCard extends StatelessWidget {
  const RecordCard({
    super.key,
    required this.title,
    required this.kicker,
    required this.trailing,
    required this.details,
  });

  final String title;
  final String kicker;
  final Widget trailing;
  final List<(String, String)> details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return AniTecPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall),
                    Text(
                      kicker,
                      style: theme.textTheme.bodySmall?.copyWith(color: muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              trailing,
            ],
          ),
          for (final (label, value) in details)
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                  TextSpan(text: value, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Centered placeholder message.
class EmptyState extends StatelessWidget {
  const EmptyState(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Inline error text.
class ErrorMessage extends StatelessWidget {
  const ErrorMessage(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.error,
      ),
    );
  }
}

/// Full-width strip above the content, used for connection and refresh problems.
class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.message,
    required this.severity,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final Severity severity;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.statusColors.of(severity);
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.container,
          borderRadius: BorderRadius.circular(aniTecRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: palette.content),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.content,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (actionLabel != null)
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: palette.content,
                    textStyle: theme.textTheme.labelMedium,
                  ),
                  child: Text(actionLabel!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
