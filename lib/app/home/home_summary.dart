import '../../activities/domain/activity.dart';
import '../../livestock/domain/livestock.dart';
import '../../sanitary/domain/health_event.dart';

/// What the dashboard loaded, already restricted to the signed-in rancher.
class HomeData {
  const HomeData({
    required this.herds,
    required this.animals,
    required this.events,
    required this.activities,
    required this.today,
  });

  final List<Herd> herds;
  final List<Animal> animals;
  final List<HealthEvent> events;
  final List<Activity> activities;

  /// Day of the load; "upcoming" and "overdue" are relative to it.
  final DateTime today;

  /// Applies the client-side visibility rules to what the API returned for everyone.
  factory HomeData.scoped({
    required int userId,
    required List<Herd> herds,
    required List<Animal> animals,
    required List<HealthEvent> events,
    required List<Activity> activities,
    required DateTime today,
  }) {
    final visibleHerds = LivestockScope.visibleHerds(userId, herds);
    // Archived animals are kept on the server but do not count in the herd, like in the Android app.
    final visibleAnimals = LivestockScope.visibleAnimals(
      animals,
      visibleHerds,
    ).where((animal) => !animal.isArchived).toList();
    return HomeData(
      herds: visibleHerds,
      animals: visibleAnimals,
      events: SanitaryScope.visibleEvents(events, {
        for (final animal in visibleAnimals) animal.id,
      }),
      activities: ActivityScope.visibleToRancher(activities, userId),
      today: today,
    );
  }
}

class RecentRecord {
  const RecentRecord(this.event, this.animalName);

  final HealthEvent event;
  final String animalName;
}

/// Counters and lists of the dashboard for all farms or one selected farm.
class HomeSummary {
  const HomeSummary({
    required this.selectedHerdId,
    required this.animalCount,
    required this.attentionCount,
    required this.recordCount,
    required this.followUpCount,
    required this.upcomingCount,
    required this.upcoming,
    required this.recent,
  });

  /// Null for "all farms". A selection that is no longer among the herds falls back to null.
  final int? selectedHerdId;
  final int animalCount;
  final int attentionCount;
  final int recordCount;
  final int followUpCount;
  final int upcomingCount;

  /// Next three activities, soonest first.
  final List<Activity> upcoming;

  /// Four most recent health records, newest first.
  final List<RecentRecord> recent;

  factory HomeSummary.of(HomeData data, {int? selectedHerdId}) {
    final selected = data.herds.any((herd) => herd.id == selectedHerdId)
        ? selectedHerdId
        : null;
    final animals = data.animals
        .where((animal) => selected == null || animal.herdId == selected)
        .toList();
    final animalIds = {for (final animal in animals) animal.id};
    final names = {for (final animal in data.animals) animal.id: animal.name};
    final events =
        data.events.where((e) => animalIds.contains(e.animalId)).toList()
          ..sort((a, b) {
            final byDate = b.date.compareTo(a.date);
            return byDate != 0 ? byDate : b.id.compareTo(a.id);
          });
    final upcoming =
        data.activities.where((a) => a.isUpcoming(data.today)).toList()
          ..sort((a, b) {
            final byDate = a.date.compareTo(b.date);
            return byDate != 0 ? byDate : a.id.compareTo(b.id);
          });
    return HomeSummary(
      selectedHerdId: selected,
      animalCount: animals.length,
      attentionCount: animals
          .where((a) => a.healthStatus.needsAttention)
          .length,
      recordCount: events.length,
      followUpCount: events.where((e) => e.hasFollowUp).length,
      upcomingCount: upcoming.length,
      upcoming: upcoming.take(3).toList(),
      recent: [
        for (final event in events.take(4))
          RecentRecord(event, names[event.animalId] ?? ''),
      ],
    );
  }
}
