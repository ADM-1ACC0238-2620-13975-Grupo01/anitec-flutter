import 'package:flutter/material.dart';

import '../../core/designsystem/components.dart';
import '../../core/designsystem/status_colors.dart';
import '../../core/util/iso_date.dart';
import '../../l10n/app_localizations.dart';
import '../domain/health_event.dart';

/// Localized label of a record type; unknown values (the API stores free text) are shown as they are.
String healthTypeLabel(AppLocalizations l10n, String type) => switch (type) {
  HealthTypes.incident => l10n.healthTypeIncident,
  HealthTypes.vaccine => l10n.healthTypeVaccine,
  HealthTypes.treatment => l10n.healthTypeTreatment,
  HealthTypes.diagnosis => l10n.healthTypeDiagnosis,
  HealthTypes.checkup => l10n.healthTypeCheckup,
  _ => type,
};

/// Card of one health record on the dashboard.
class HealthRecordCard extends StatelessWidget {
  const HealthRecordCard({
    super.key,
    required this.event,
    required this.animalName,
  });

  final HealthEvent event;
  final String animalName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nextDue = event.nextDueDate;
    return RecordCard(
      title: animalName.isEmpty ? '${event.animalId}' : animalName,
      kicker: displayApiDay(event.date),
      trailing: event.hasFollowUp
          ? StatusTag(l10n.healthTagFollowUp, Severity.warn)
          : StatusTag(l10n.healthTagClosed, Severity.success),
      details: [
        (l10n.healthType, healthTypeLabel(l10n, event.type)),
        (l10n.healthDescription, event.description),
        if (event.veterinarian.isNotEmpty)
          (l10n.healthVeterinarian, event.veterinarian),
        if (event.diagnosis.isNotEmpty) (l10n.healthDiagnosis, event.diagnosis),
        if (event.treatment.isNotEmpty) (l10n.healthTreatment, event.treatment),
        if (event.prescription.isNotEmpty)
          (l10n.healthPrescription, event.prescription),
        if (event.followUp.isNotEmpty) (l10n.healthFollowUp, event.followUp),
        if (nextDue != null) (l10n.healthNextDue, displayApiDay(nextDue)),
      ],
    );
  }
}
