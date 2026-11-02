import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/network_providers.dart';
import 'data/livestock_repository_impl.dart';
import 'domain/livestock_repository.dart';

/// Livestock repository used by the dashboard.
final livestockRepositoryProvider = Provider<LivestockRepository>(
  (ref) => LivestockRepositoryImpl(ref.watch(dioProvider)),
);
