// Feature context: sanitary data access contract.

import 'health_event.dart';

/// Reads health records from the API. Failures surface as `AppException`.
abstract interface class SanitaryRepository {
  Future<List<HealthEvent>> fetchEvents();
}
