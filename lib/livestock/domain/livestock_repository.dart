import 'livestock.dart';

/// Reads livestock from the API. Failures surface as `AppException`.
abstract interface class LivestockRepository {
  Future<List<Herd>> fetchHerds();

  Future<List<Animal>> fetchAnimals();
}
