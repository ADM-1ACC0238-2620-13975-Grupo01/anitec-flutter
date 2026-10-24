/// A health record of one animal. Dates are ISO (`yyyy-MM-dd`).
class HealthEvent {
  const HealthEvent({
    required this.id,
    required this.animalId,
    required this.type,
    required this.date,
    this.description = '',
    this.veterinarian = '',
    this.diagnosis = '',
    this.treatment = '',
    this.prescription = '',
    this.followUp = '',
    this.nextDueDate,
  });

  final int id;
  final int animalId;

  /// Raw API text; see [HealthTypes].
  final String type;
  final String date;
  final String description;
  final String veterinarian;
  final String diagnosis;
  final String treatment;
  final String prescription;
  final String followUp;
  final String? nextDueDate;

  /// Open events carry a next due date; the dashboard counts them as pending follow-ups.
  bool get hasFollowUp => nextDueDate != null;
}

/// Kinds of record the web offers; the API stores them as free text.
abstract final class HealthTypes {
  static const incident = 'Incidencia';
  static const vaccine = 'Vacuna';
  static const treatment = 'Tratamiento';
  static const diagnosis = 'Diagnostico';
  static const checkup = 'Revision';
}

abstract final class SanitaryScope {
  /// The API returns every record; a user only sees the ones of animals they can see.
  static List<HealthEvent> visibleEvents(
    List<HealthEvent> events,
    Set<int> visibleAnimalIds,
  ) => events
      .where((event) => visibleAnimalIds.contains(event.animalId))
      .toList();
}
