import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'locale_controller.dart';

/// App bar button that switches between English and Spanish.
class LanguageMenu extends ConsumerWidget {
  const LanguageMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current = ref.watch(languageControllerProvider);
    return PopupMenuButton<AppLanguage>(
      tooltip: l10n.languageLabel,
      icon: const Icon(Icons.translate),
      initialValue: current,
      onSelected: ref.read(languageControllerProvider.notifier).select,
      itemBuilder: (context) => [
        for (final language in AppLanguage.values)
          CheckedPopupMenuItem(
            value: language,
            checked: language == current,
            child: Text(switch (language) {
              AppLanguage.english => l10n.languageEnglish,
              AppLanguage.spanish => l10n.languageSpanish,
            }),
          ),
      ],
    );
  }
}
