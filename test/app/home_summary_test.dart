import 'package:anitec_flutter/activities/domain/activity.dart';
import 'package:anitec_flutter/app/home/home_summary.dart';
import 'package:anitec_flutter/sanitary/domain/health_event.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart' as fx;

HomeData scopedFor(int userId) => HomeData.scoped(
  userId: userId,
  herds: fx.herds,
  animals: fx.animals,
  events: fx.events,
  activities: fx.activities,
  today: fx.today,
);

void main() {
  group('HomeData.scoped', () {
    test('keeps only what belongs to the rancher', () {
      final data = scopedFor(7);
      expect(data.herds.map((h) => h.id), [1, 2]);
      expect(data.animals.map((a) => a.id), [1, 2, 3]);
      expect(data.events.map((e) => e.id), [1, 2]);
      expect(data.activities.map((a) => a.id), [1, 2, 3]);
    });

    test('a user without data gets an empty dashboard', () {
      final data = scopedFor(1234);
      expect(data.herds, isEmpty);
      expect(data.animals, isEmpty);
      expect(data.events, isEmpty);
      expect(data.activities, isEmpty);
    });
  });

  group('HomeSummary.of for all farms', () {
    final summary = HomeSummary.of(scopedFor(7));

    test('counts animals, the ones needing attention and the records', () {
      expect(summary.selectedHerdId, isNull);
      expect(summary.animalCount, 3);
      expect(summary.attentionCount, 2);
      expect(summary.recordCount, 2);
      expect(summary.followUpCount, 1);
    });

    test(
      'lists upcoming activities soonest first, without done or past ones',
      () {
        expect(summary.upcomingCount, 1);
        expect(summary.upcoming.map((a) => a.id), [1]);
      },
    );

    test('lists the newest records first with the animal name', () {
      expect(summary.recent.map((r) => r.event.id), [2, 1]);
      expect(summary.recent.map((r) => r.animalName), ['Tita', 'Luna']);
    });
  });

  group('HomeSummary.of with a selected farm', () {
    test('narrows animals and records to that farm', () {
      final summary = HomeSummary.of(scopedFor(7), selectedHerdId: 1);
      expect(summary.selectedHerdId, 1);
      expect(summary.animalCount, 2);
      expect(summary.attentionCount, 1);
      expect(summary.recordCount, 1);
      expect(summary.followUpCount, 1);
      expect(summary.recent.single.animalName, 'Luna');
    });

    test('activities do not depend on the farm', () {
      final summary = HomeSummary.of(scopedFor(7), selectedHerdId: 2);
      expect(summary.upcomingCount, 1);
    });

    test('a farm that is not the rancher\'s falls back to all farms', () {
      final summary = HomeSummary.of(scopedFor(7), selectedHerdId: 3);
      expect(summary.selectedHerdId, isNull);
      expect(summary.animalCount, 3);
    });
  });

  test('shows at most 3 upcoming activities and 4 recent records', () {
    final data = HomeData(
      herds: fx.herds.take(1).toList(),
      animals: [fx.animals.first],
      events: [
        for (var i = 1; i <= 6; i++)
          HealthEvent(
            id: i,
            animalId: 1,
            type: HealthTypes.checkup,
            date: '2026-10-0$i',
          ),
      ],
      activities: [
        for (var i = 1; i <= 5; i++)
          Activity(
            id: i,
            ownerId: 7,
            title: 'a$i',
            type: ActivityTypes.health,
            date: '2026-11-0${6 - i}',
            priority: ActivityPriorities.low,
            status: ActivityStatuses.pending,
          ),
      ],
      today: fx.today,
    );
    final summary = HomeSummary.of(data);
    expect(summary.upcomingCount, 5);
    expect(summary.upcoming.map((a) => a.id), [5, 4, 3]);
    expect(summary.recordCount, 6);
    expect(summary.recent.map((r) => r.event.id), [6, 5, 4, 3]);
  });
}
