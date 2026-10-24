import 'animal_status.dart';

/// A farm (the web UI calls it "Finca"). It groups corrals and animals.
class Herd {
  const Herd({required this.id, required this.name, required this.ownerId});

  final int id;
  final String name;
  final int ownerId;
}

class Animal {
  const Animal({
    required this.id,
    required this.name,
    required this.status,
    required this.herdId,
  });

  final int id;
  final String name;

  /// Raw API text: the backend stores free text in mixed languages.
  final String status;
  final int herdId;

  AnimalStatus get healthStatus => AnimalStatus.fromApi(status);
}

/// Client-side visibility rules for livestock data.
///
/// The API returns every herd and animal, so the client decides, as the Android app does: a rancher
/// sees the herds they own, and animals only inside those herds.
abstract final class LivestockScope {
  static List<Herd> visibleHerds(int userId, List<Herd> herds) =>
      herds.where((herd) => herd.ownerId == userId).toList();

  static List<Animal> visibleAnimals(List<Animal> animals, List<Herd> herds) {
    final herdIds = {for (final herd in herds) herd.id};
    return animals.where((animal) => herdIds.contains(animal.herdId)).toList();
  }
}
