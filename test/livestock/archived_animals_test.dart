import 'package:anitec_flutter/app/home/home_summary.dart';
import 'package:anitec_flutter/livestock/domain/animal_status.dart';
import 'package:anitec_flutter/livestock/domain/livestock.dart';
import 'package:anitec_flutter/sanitary/domain/health_event.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart' as fx;

void main() {
  group('archived status', () {
    test('is read in both spellings and does not need attention', () {
      expect(AnimalStatus.fromApi('Archivado'), AnimalStatus.archived);
      expect(AnimalStatus.fromApi(' archived '), AnimalStatus.archived);
      expect(AnimalStatus.archived.needsAttention, isFalse);
    });

    test('an animal knows whether it is archived', () {
      const archived = Animal(id: 1, name: 'A', status: 'Archivado', herdId: 1);
      const healthy = Animal(id: 2, name: 'B', status: 'Saludable', herdId: 1);
      expect(archived.isArchived, isTrue);
      expect(healthy.isArchived, isFalse);
    });
  });

  group('the dashboard leaves archived animals out', () {
    final animals = [
      ...fx.animals,
      const Animal(id: 900, name: 'Old', status: 'Archivado', herdId: 1),
    ];
    final events = [
      ...fx.events,
      const HealthEvent(
        id: 900,
        animalId: 900,
        type: 'Incidencia',
        date: '2026-10-01',
      ),
    ];

    HomeData scoped() => HomeData.scoped(
      userId: 7,
      herds: fx.herds,
      animals: animals,
      events: events,
      activities: fx.activities,
      today: fx.today,
    );

    test('their animals, records and counters do not appear', () {
      final data = scoped();
      expect(data.animals.map((a) => a.id), isNot(contains(900)));
      expect(data.events.map((e) => e.id), isNot(contains(900)));

      final summary = HomeSummary.of(data);
      expect(summary.animalCount, 3);
      expect(summary.recordCount, 2);
    });
  });
}
