import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../activities/presentation/activity_card.dart';
import '../../core/designsystem/components.dart';
import '../../core/designsystem/status_colors.dart';
import '../../core/i18n/error_messages.dart';
import '../../core/i18n/language_menu.dart';
import '../../core/network/app_error.dart';
import '../../core/session/session_controller.dart';
import '../../core/session/user_session.dart';
import '../../l10n/app_localizations.dart';
import '../../sanitary/presentation/health_record_card.dart';
import 'home_controller.dart';
import 'home_summary.dart';

enum _MenuAction { terms, signOut }

/// Rancher dashboard: farm filter, counters, upcoming activities and recent health records.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = switch (ref.watch(sessionControllerProvider)) {
      SignedIn(:final session) => session,
      _ => null,
    };
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);
    final summary = state.summary;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          const LanguageMenu(),
          PopupMenuButton<_MenuAction>(
            tooltip: l10n.menuMore,
            onSelected: (action) {
              switch (action) {
                case _MenuAction.terms:
                  context.push('/terms');
                case _MenuAction.signOut:
                  ref.read(sessionControllerProvider.notifier).signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _MenuAction.terms,
                child: Text(l10n.menuTerms),
              ),
              PopupMenuItem(
                value: _MenuAction.signOut,
                child: Text(l10n.menuSignOut),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refresh,
          child: summary == null
              ? _Placeholder(state: state, onRetry: controller.refresh)
              : _Dashboard(
                  session: session,
                  state: state,
                  summary: summary,
                  onHerdSelected: controller.onHerdSelected,
                  onRetry: controller.refresh,
                ),
        ),
      ),
    );
  }
}

/// First load: a spinner, or the error with a retry when it failed.
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.state, required this.onRetry});

  final HomeState state;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final error = state.error;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                if (error == null) ...[
                  const CircularProgressIndicator(),
                  Text(
                    l10n.homeLoadingHint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ] else ...[
                  Icon(
                    error is NetworkError
                        ? Icons.wifi_off
                        : Icons.error_outline,
                    size: 40,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  Text(
                    appErrorMessage(l10n, error),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  FilledButton(
                    onPressed: onRetry,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(160, 48),
                    ),
                    child: Text(l10n.commonRetry),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({
    required this.session,
    required this.state,
    required this.summary,
    required this.onHerdSelected,
    required this.onRetry,
  });

  final UserSession? session;
  final HomeState state;
  final HomeSummary summary;
  final ValueChanged<int?> onHerdSelected;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final data = state.data!;
    final error = state.error;
    final user = session;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        if (error != null) ...[
          StatusBanner(
            message: error is NetworkError
                ? l10n.homeOfflineBanner
                : l10n.homeRefreshFailedBanner,
            severity: Severity.warn,
            icon: error is NetworkError ? Icons.wifi_off : Icons.error_outline,
            actionLabel: l10n.commonRetry,
            onAction: onRetry,
          ),
          const SizedBox(height: 14),
        ],
        if (user != null) ...[
          _GreetingPanel(session: user),
          const SizedBox(height: 14),
        ],
        if (data.herds.isNotEmpty) ...[
          DropdownMenu<int?>(
            key: ValueKey(summary.selectedHerdId),
            expandedInsets: EdgeInsets.zero,
            label: Text(l10n.homeFarmFilter),
            leadingIcon: const Icon(Icons.home_work_outlined),
            initialSelection: summary.selectedHerdId,
            onSelected: onHerdSelected,
            dropdownMenuEntries: [
              DropdownMenuEntry<int?>(value: null, label: l10n.homeAllFarms),
              for (final herd in data.herds)
                DropdownMenuEntry<int?>(value: herd.id, label: herd.name),
            ],
          ),
          const SizedBox(height: 14),
        ],
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              Expanded(
                child: MetricCard(
                  label: l10n.homeMetricAnimals,
                  value: '${summary.animalCount}',
                  icon: Icons.pets,
                ),
              ),
              Expanded(
                child: MetricCard(
                  label: l10n.homeMetricAttention,
                  value: '${summary.attentionCount}',
                  icon: Icons.warning_amber_rounded,
                  caption: l10n.homeMetricAttentionCaption,
                  valueColor: summary.attentionCount > 0
                      ? theme.colorScheme.error
                      : null,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              Expanded(
                child: MetricCard(
                  label: l10n.homeMetricRecords,
                  value: '${summary.recordCount}',
                  icon: Icons.favorite_border,
                ),
              ),
              Expanded(
                child: MetricCard(
                  label: l10n.homeMetricFollowUps,
                  value: '${summary.followUpCount}',
                  icon: Icons.event_repeat,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: MetricCard(
            label: l10n.homeMetricUpcoming,
            value: '${summary.upcomingCount}',
            icon: Icons.event,
          ),
        ),
        const SizedBox(height: 20),
        Text(l10n.homeUpcomingTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (summary.upcoming.isEmpty)
          EmptyState(l10n.homeUpcomingEmpty)
        else
          for (final activity in summary.upcoming) ...[
            ActivityCard(activity: activity, today: data.today),
            const SizedBox(height: 10),
          ],
        const SizedBox(height: 10),
        Text(l10n.homeRecentTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (summary.recent.isEmpty)
          EmptyState(l10n.homeRecentEmpty)
        else
          for (final record in summary.recent) ...[
            HealthRecordCard(
              event: record.event,
              animalName: record.animalName,
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

/// Top panel with the app chip, personalized greeting, subtitle and role tag.
class _GreetingPanel extends StatelessWidget {
  const _GreetingPanel({required this.session});

  final UserSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: AniTecPanel(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            SectionChip(l10n.appName),
            Text(
              l10n.homeGreeting(session.fullName),
              style: theme.textTheme.headlineMedium,
            ),
            Text(
              l10n.homeSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            StatusTag(switch (session.role) {
              UserRole.rancher => l10n.roleRancher,
              UserRole.veterinarian => l10n.roleVeterinarian,
            }, Severity.success),
          ],
        ),
      ),
    );
  }
}
