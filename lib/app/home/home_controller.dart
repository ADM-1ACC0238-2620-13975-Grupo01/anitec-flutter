import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../activities/activities_providers.dart';
import '../../activities/domain/activity.dart';
import '../../core/network/app_error.dart';
import '../../core/session/session_controller.dart';
import '../../livestock/domain/livestock.dart';
import '../../livestock/livestock_providers.dart';
import '../../sanitary/domain/health_event.dart';
import '../../sanitary/sanitary_providers.dart';
import 'home_summary.dart';

/// Source of "today"; tests replace it.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Dashboard state: the loaded data, the selected farm and the refresh status.
class HomeState {
  const HomeState({
    this.data,
    this.selectedHerdId,
    this.refreshing = false,
    this.error,
  });

  /// Null until the first load succeeds.
  final HomeData? data;

  /// Farm shown on the dashboard; null shows all of them.
  final int? selectedHerdId;
  final bool refreshing;

  /// Why the last load failed; cleared when the next one starts.
  final AppError? error;

  /// Counters and recent records for the selected farm; null until the data loads.
  HomeSummary? get summary {
    final loaded = data;
    if (loaded == null) return null;
    return HomeSummary.of(loaded, selectedHerdId: selectedHerdId);
  }
  /// Creates a copy of this [HomeState] with the given fields replaced with new values.
  /// Supports clearing optional fields like [selectedHerdId] and [error] using explicit flags.
  HomeState copyWith({
    HomeData? data,
    int? selectedHerdId,
    bool clearSelectedHerd = false,
    bool? refreshing,
    AppError? error,
    bool clearError = false,
  }) => HomeState(
    data: data ?? this.data,
    selectedHerdId: clearSelectedHerd
        ? null
        : selectedHerdId ?? this.selectedHerdId,
    refreshing: refreshing ?? this.refreshing,
    error: clearError ? null : error ?? this.error,
  );
}

/// Dashboard controller; disposed when the screen closes.
final homeControllerProvider =
    NotifierProvider.autoDispose<HomeController, HomeState>(HomeController.new);

/// Dashboard of the rancher: counters and recent records for all farms or one selected farm.
class HomeController extends Notifier<HomeState> {
  late int _userId;
  bool _inFlight = false;

  @override
  HomeState build() {
    final session = ref.read(sessionControllerProvider);
    _userId = switch (session) {
      SignedIn(:final session) => session.userId,
      _ => -1,
    };
    Future.microtask(refresh);
    return const HomeState(refreshing: true);
  }

  /// Loads herds, animals, health events and activities in parallel and keeps the user's own data.
  /// A refresh that is already running is not started again.
  Future<void> refresh() async {
    if (!ref.mounted || _inFlight) return;
    _inFlight = true;
    state = state.copyWith(refreshing: true, clearError: true);
    try {
      final results = await Future.wait<Object>([
        ref.read(livestockRepositoryProvider).fetchHerds(),
        ref.read(livestockRepositoryProvider).fetchAnimals(),
        ref.read(sanitaryRepositoryProvider).fetchEvents(),
        ref.read(activitiesRepositoryProvider).fetchActivities(),
      ]);
      if (!ref.mounted) return;
      state = state.copyWith(
        refreshing: false,
        data: HomeData.scoped(
          userId: _userId,
          herds: results[0] as List<Herd>,
          animals: results[1] as List<Animal>,
          events: results[2] as List<HealthEvent>,
          activities: results[3] as List<Activity>,
          today: ref.read(clockProvider)(),
        ),
      );
    } on AppException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(refreshing: false, error: e.error);
    } finally {
      _inFlight = false;
    }
  }

  /// Shows one farm on the dashboard, or all of them when [herdId] is null.
  void onHerdSelected(int? herdId) => state = herdId == null
      ? state.copyWith(clearSelectedHerd: true)
      : state.copyWith(selectedHerdId: herdId);
}
