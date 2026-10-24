import 'package:anitec_flutter/livestock/domain/animal_status.dart';
import 'package:anitec_flutter/livestock/domain/livestock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart' as fx;

void main() {
  group('AnimalStatus.fromApi', () {
    test('reads the Spanish values the web sends', () {
      expect(AnimalStatus.fromApi('Saludable'), AnimalStatus.healthy);
      expect(AnimalStatus.fromApi('Observacion'), AnimalStatus.observation);
      expect(AnimalStatus.fromApi('En tratamiento'), AnimalStatus.inTreatment);
      expect(AnimalStatus.fromApi('Vendido'), AnimalStatus.sold);
    });

    test('is case and space insensitive and knows the English seed values', () {
      expect(
        AnimalStatus.fromApi('  EN TRATAMIENTO '),
        AnimalStatus.inTreatment,
      );
      expect(AnimalStatus.fromApi('healthy'), AnimalStatus.healthy);
      expect(AnimalStatus.fromApi('Sick'), AnimalStatus.inTreatment);
    });

    test('falls back to unknown', () {
      expect(AnimalStatus.fromApi(null), AnimalStatus.unknown);
      expect(AnimalStatus.fromApi(''), AnimalStatus.unknown);
      expect(AnimalStatus.fromApi('???'), AnimalStatus.unknown);
    });

    test('only observation and in treatment need attention', () {
      final needing = AnimalStatus.values.where((s) => s.needsAttention);
      expect(needing, [AnimalStatus.observation, AnimalStatus.inTreatment]);
    });
  });

  group('LivestockScope', () {
    test('a rancher only sees the herds they own', () {
      final visible = LivestockScope.visibleHerds(7, fx.herds);
      expect(visible.map((h) => h.id), [1, 2]);
    });

    test('animals are restricted to the visible herds', () {
      final visibleHerds = LivestockScope.visibleHerds(7, fx.herds);
      final visible = LivestockScope.visibleAnimals(fx.animals, visibleHerds);
      expect(visible.map((a) => a.name), ['Luna', 'Mora', 'Tita']);
    });

    test('a rancher without herds sees no animals', () {
      final visibleHerds = LivestockScope.visibleHerds(1234, fx.herds);
      expect(visibleHerds, isEmpty);
      expect(LivestockScope.visibleAnimals(fx.animals, visibleHerds), isEmpty);
    });
  });
}
