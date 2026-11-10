// Feature context: activity module dependency providers.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/network_providers.dart';
import 'data/activities_repository_impl.dart';
import 'domain/activities_repository.dart';

/// Farm activities repository used by the dashboard.
final activitiesRepositoryProvider = Provider<ActivitiesRepository>(
  (ref) => ActivitiesRepositoryImpl(ref.watch(dioProvider)),
);
