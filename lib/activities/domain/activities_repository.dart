import 'activity.dart';

/// Reads farm activities from the API. Failures surface as `AppException`.
abstract interface class ActivitiesRepository {
  Future<List<Activity>> fetchActivities();
}
