import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/network_providers.dart';
import 'data/activities_repository_impl.dart';
import 'domain/activities_repository.dart';

final activitiesRepositoryProvider = Provider<ActivitiesRepository>(
  (ref) => ActivitiesRepositoryImpl(ref.watch(dioProvider)),
);
