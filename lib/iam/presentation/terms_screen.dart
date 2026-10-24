import 'package:flutter/material.dart';

import '../../core/designsystem/components.dart';
import '../../l10n/app_localizations.dart';

/// Terms of Service. Reachable signed in or out.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final sections = [
      (l10n.termsSectionUseTitle, l10n.termsSectionUseBody),
      (l10n.termsSectionAccountTitle, l10n.termsSectionAccountBody),
      (l10n.termsSectionDataTitle, l10n.termsSectionDataBody),
      (l10n.termsSectionEthicsTitle, l10n.termsSectionEthicsBody),
      (l10n.termsSectionPaymentsTitle, l10n.termsSectionPaymentsBody),
      (l10n.termsSectionAvailabilityTitle, l10n.termsSectionAvailabilityBody),
      (l10n.termsSectionChangesTitle, l10n.termsSectionChangesBody),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.termsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AniTecPanel(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(l10n.termsIntro, style: theme.textTheme.bodyMedium),
                  for (final (title, body) in sections) ...[
                    const SizedBox(height: 8),
                    Text(title, style: theme.textTheme.titleSmall),
                    Text(
                      body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
