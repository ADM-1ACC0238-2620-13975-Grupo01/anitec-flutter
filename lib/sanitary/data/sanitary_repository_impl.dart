// Feature context: remote sanitary record synchronization.

import 'package:dio/dio.dart';

import '../../core/network/app_error.dart';
import '../../core/network/json_reader.dart';
import '../domain/health_event.dart';
import '../domain/sanitary_repository.dart';

/// [SanitaryRepository] backed by the `health-events` endpoint of the API.
class SanitaryRepositoryImpl implements SanitaryRepository {
  const SanitaryRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<HealthEvent>> fetchEvents() => guardApi(() async {
    final response = await _dio.get<Object?>('health-events');
    return jsonList(response.data).map(_eventFromJson).toList();
  });
}

/// Reads a health event; [HealthEvent.nextDueDate] stays null when the API omits it.
HealthEvent _eventFromJson(Map<String, dynamic> json) => HealthEvent(
  id: json.intOf('id'),
  animalId: json.intOf('animalId'),
  type: json.stringOf('type'),
  date: json.stringOf('date'),
  description: json.stringOf('description'),
  veterinarian: json.stringOf('veterinarian'),
  diagnosis: json.stringOf('diagnosis'),
  treatment: json.stringOf('treatment'),
  prescription: json.stringOf('prescription'),
  followUp: json.stringOf('followUp'),
  nextDueDate: json.stringOrNull('nextDueDate'),
);
