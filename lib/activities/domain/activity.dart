import '../../core/util/iso_date.dart';

/// A scheduled farm task. `ownerId` is the rancher it concerns. Dates are ISO (`yyyy-MM-dd`);
/// [type], [priority] and [status] keep the API text.
class Activity {
  const Activity({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.type,
    required this.date,
    required this.priority,
    required this.status,
  });

  final int id;
  final int? ownerId;
  final String title;
  final String type;
  final String date;
  final String priority;
  final String status;

  bool get isCompleted =>
      status.toLowerCase() == ActivityStatuses.completed.toLowerCase();

  /// Still to be done: not completed and not in the past.
  bool isUpcoming(DateTime today) {
    if (isCompleted) return false;
    final day = parseApiDay(date);
    return day != null && !day.isBefore(_dayOf(today));
  }

  /// Not completed and already past.
  bool isOverdue(DateTime today) {
    if (isCompleted) return false;
    final day = parseApiDay(date);
    return day != null && day.isBefore(_dayOf(today));
  }

  static DateTime _dayOf(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}

abstract final class ActivityTypes {
  static const health = 'Sanitario';
  static const vetVisit = 'Visita veterinaria';
  static const production = 'Productivo';
  static const financial = 'Financiero';
  static const reproductive = 'Reproductivo';
}

abstract final class ActivityPriorities {
  static const high = 'Alta';
  static const medium = 'Media';
  static const low = 'Baja';
}

abstract final class ActivityStatuses {
  static const pending = 'Pendiente';
  static const scheduled = 'Programado';
  static const completed = 'Completado';
}

abstract final class ActivityScope {
  /// The API returns every activity, so the client filters: a rancher sees the ones about them.
  static List<Activity> visibleToRancher(
    List<Activity> activities,
    int userId,
  ) => activities.where((activity) => activity.ownerId == userId).toList();
}
