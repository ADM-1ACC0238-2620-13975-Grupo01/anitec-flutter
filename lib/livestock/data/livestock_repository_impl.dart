import 'package:dio/dio.dart';

import '../../core/network/app_error.dart';
import '../../core/network/json_reader.dart';
import '../domain/livestock.dart';
import '../domain/livestock_repository.dart';

class LivestockRepositoryImpl implements LivestockRepository {
  const LivestockRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Herd>> fetchHerds() => guardApi(() async {
    final response = await _dio.get<Object?>('herds');
    return jsonList(response.data).map(_herdFromJson).toList();
  });

  @override
  Future<List<Animal>> fetchAnimals() => guardApi(() async {
    final response = await _dio.get<Object?>('animals');
    return jsonList(response.data).map(_animalFromJson).toList();
  });
}

Herd _herdFromJson(Map<String, dynamic> json) => Herd(
  id: json.intOf('id'),
  name: json.stringOf('name'),
  ownerId: json.intOf('ownerId'),
);

Animal _animalFromJson(Map<String, dynamic> json) => Animal(
  id: json.intOf('id'),
  name: json.stringOf('name'),
  status: json.stringOf('status'),
  herdId: json.intOf('herdId'),
);
