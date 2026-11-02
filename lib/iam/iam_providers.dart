import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/network_providers.dart';
import 'data/auth_repository_impl.dart';
import 'domain/auth_repository.dart';

/// Authentication repository used by the sign-in flow.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(dioProvider)),
);
