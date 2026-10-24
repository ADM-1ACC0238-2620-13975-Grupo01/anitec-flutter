import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/network_providers.dart';
import 'data/sanitary_repository_impl.dart';
import 'domain/sanitary_repository.dart';

final sanitaryRepositoryProvider = Provider<SanitaryRepository>(
  (ref) => SanitaryRepositoryImpl(ref.watch(dioProvider)),
);
