import 'package:flutter/material.dart';

import '../../core/designsystem/components.dart';
import '../../core/designsystem/status_colors.dart';
import '../../core/util/iso_date.dart';
import '../../l10n/app_localizations.dart';
import '../domain/activity.dart';

/// Localized label; unknown values (the API stores free text) are shown as they are.
String activityTypeLabel(AppLocalizations l10n, String type) => switch (type) {
  ActivityTypes.health => l10n.activityTypeHealth,
  ActivityTypes.vetVisit || 'VeterinaryVisit' => l10n.activityTypeVetVisit,
  ActivityTypes.production => l10n.activityTypeProduction,
  ActivityTypes.financial || 'FinancialTask' => l10n.activityTypeFinancial,
  ActivityTypes.reproductive => l10n.activityTypeReproductive,
  'Vaccination' => l10n.activityTypeVaccination,
  'TreatmentFollowUp' => l10n.activityTypeTreatmentFollowUp,
  _ => type,
};

String activityPriorityLabel(AppLocalizations l10n, String priority) =>
    switch (priority) {
      ActivityPriorities.high => l10n.activityPriorityHigh,
      ActivityPriorities.medium => l10n.activityPriorityMedium,
      ActivityPriorities.low => l10n.activityPriorityLow,
      _ => priority,
    };

String activityStatusLabel(AppLocalizations l10n, String status) =>
    switch (status) {
      ActivityStatuses.pending => l10n.activityStatusPending,
      ActivityStatuses.scheduled => l10n.activityStatusScheduled,
      ActivityStatuses.completed => l10n.activityStatusCompleted,
      _ => status,
    };

/// High priority is red, medium amber, anything else blue, as in the web.
Severity activityPrioritySeverity(String priority) => switch (priority) {
  ActivityPriorities.high => Severity.danger,
  ActivityPriorities.medium => Severity.warn,
  _ => Severity.info,
};

/// Card of one activity on the dashboard.
class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity, required this.today});

  final Activity activity;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = displayApiDay(activity.date);
    return RecordCard(
      title: activity.title,
      kicker: activity.isOverdue(today)
          ? '$date · ${l10n.activityOverdue}'
          : date,
      trailing: StatusTag(
        activityPriorityLabel(l10n, activity.priority),
        activityPrioritySeverity(activity.priority),
      ),
      details: [
        (l10n.activityType, activityTypeLabel(l10n, activity.type)),
        (l10n.activityStatus, activityStatusLabel(l10n, activity.status)),
      ],
    );
  }
}
