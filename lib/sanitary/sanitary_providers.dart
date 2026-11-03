// Feature context: sanitary module dependency providers.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/network_providers.dart';
import 'data/sanitary_repository_impl.dart';
import 'domain/sanitary_repository.dart';

/// Health events repository used by the dashboard.
final sanitaryRepositoryProvider = Provider<SanitaryRepository>(
  (ref) => SanitaryRepositoryImpl(ref.watch(dioProvider)),
);
