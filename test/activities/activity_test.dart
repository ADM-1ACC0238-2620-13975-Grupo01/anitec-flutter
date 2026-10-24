import 'package:anitec_flutter/activities/domain/activity.dart';
import 'package:flutter_test/flutter_test.dart';

Activity activity(String date, {String status = ActivityStatuses.pending}) =>
    Activity(
      id: 1,
      ownerId: 7,
      title: 't',
      type: ActivityTypes.health,
      date: date,
      priority: ActivityPriorities.low,
      status: status,
    );

void main() {
  final today = DateTime(2026, 10, 23, 15, 30);

  group('Activity.isUpcoming', () {
    test('today and the future are upcoming, the past is not', () {
      expect(activity('2026-10-23').isUpcoming(today), isTrue);
      expect(activity('2026-11-01').isUpcoming(today), isTrue);
      expect(activity('2026-10-22').isUpcoming(today), isFalse);
    });

    test('completed activities are never upcoming, whatever the case', () {
      expect(
        activity('2026-11-01', status: 'Completado').isUpcoming(today),
        isFalse,
      );
      expect(
        activity('2026-11-01', status: 'COMPLETADO').isUpcoming(today),
        isFalse,
      );
    });

    test('accepts a date with a time part and ignores unparseable dates', () {
      expect(activity('2026-10-23T00:00:00').isUpcoming(today), isTrue);
      expect(activity('soon').isUpcoming(today), isFalse);
    });
  });

  group('Activity.isOverdue', () {
    test('only past, not completed activities are overdue', () {
      expect(activity('2026-10-22').isOverdue(today), isTrue);
      expect(activity('2026-10-23').isOverdue(today), isFalse);
      expect(
        activity(
          '2026-10-01',
          status: ActivityStatuses.completed,
        ).isOverdue(today),
        isFalse,
      );
    });
  });

  test('a rancher only sees the activities about them', () {
    final all = [
      activity('2026-10-23'),
      const Activity(
        id: 2,
        ownerId: 99,
        title: 'x',
        type: '',
        date: '2026-10-23',
        priority: '',
        status: '',
      ),
      const Activity(
        id: 3,
        ownerId: null,
        title: 'y',
        type: '',
        date: '2026-10-23',
        priority: '',
        status: '',
      ),
    ];
    expect(ActivityScope.visibleToRancher(all, 7).map((a) => a.id), [1]);
  });
}
