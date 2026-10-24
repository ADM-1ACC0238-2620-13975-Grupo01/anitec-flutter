import 'package:dio/dio.dart';

import '../../core/network/app_error.dart';
import '../../core/network/json_reader.dart';
import '../domain/activities_repository.dart';
import '../domain/activity.dart';

class ActivitiesRepositoryImpl implements ActivitiesRepository {
  const ActivitiesRepositoryImpl(this._dio);

  final Dio _dio;

  /// The route is `farm-events`, not `farm-activities`.
  @override
  Future<List<Activity>> fetchActivities() => guardApi(() async {
    final response = await _dio.get<Object?>('farm-events');
    return jsonList(response.data).map(_activityFromJson).toList();
  });
}

Activity _activityFromJson(Map<String, dynamic> json) => Activity(
  id: json.intOf('id'),
  ownerId: json.intOrNull('ownerId'),
  title: json.stringOf('title'),
  type: json.stringOf('type'),
  date: json.stringOf('date'),
  priority: json.stringOf('priority'),
  status: json.stringOf('status'),
);
