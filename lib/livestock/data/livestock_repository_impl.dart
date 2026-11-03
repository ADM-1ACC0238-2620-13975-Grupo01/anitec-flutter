// Feature context: remote livestock data access.

import 'package:dio/dio.dart';

import '../../core/network/app_error.dart';
import '../../core/network/json_reader.dart';
import '../domain/livestock.dart';
import '../domain/livestock_repository.dart';

/// [LivestockRepository] backed by the `herds` and `animals` endpoints of the API.
class LivestockRepositoryImpl implements LivestockRepository {
  const LivestockRepositoryImpl(this._dio);

  final Dio _dio;
  /// Fetches the list of herds from the remote API, guarding against network errors
  /// and mapping the JSON response list to domain [Herd] entities.
  @override
  Future<List<Herd>> fetchHerds() => guardApi(() async {
    final response = await _dio.get<Object?>('herds');
    return jsonList(response.data).map(_herdFromJson).toList();
  });
  /// Fetches the list of animals from the remote API, guarding against network errors
  /// and mapping the JSON response list to domain [Animal] entities.
  @override
  Future<List<Animal>> fetchAnimals() => guardApi(() async {
    final response = await _dio.get<Object?>('animals');
    return jsonList(response.data).map(_animalFromJson).toList();
  });
}

/// Reads the herd fields used by the dashboard.
Herd _herdFromJson(Map<String, dynamic> json) => Herd(
  id: json.intOf('id'),
  name: json.stringOf('name'),
  ownerId: json.intOf('ownerId'),
);

/// Reads the animal fields used by the dashboard.
Animal _animalFromJson(Map<String, dynamic> json) => Animal(
  id: json.intOf('id'),
  name: json.stringOf('name'),
  status: json.stringOf('status'),
  herdId: json.intOf('herdId'),
);
