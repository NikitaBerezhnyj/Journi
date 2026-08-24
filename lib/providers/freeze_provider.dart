import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/analytics_service.dart';
import '../services/freeze_service.dart';

class FreezeState {
  final int freezesAvailable;
  final Set<String> freezeUsedDates;
  final int daysWrittenAfterFreeze;

  const FreezeState({
    required this.freezesAvailable,
    required this.freezeUsedDates,
    required this.daysWrittenAfterFreeze,
  });
}

class FreezeNotifier extends AsyncNotifier<FreezeState> {
  @override
  Future<FreezeState> build() => _load();

  Future<FreezeState> _load() async {
    final service = ref.read(freezeServiceProvider);
    return FreezeState(
      freezesAvailable: service.getFreezesAvailable(),
      freezeUsedDates: await service.getFreezeUsedDates(),
      daysWrittenAfterFreeze: service.getDaysWrittenAfterFreeze(),
    );
  }

  Future<void> applyFreezeIfNeeded({
    required DateTime today,
    required Map<String, bool> diaryMap,
  }) async {
    final changed = await ref
        .read(freezeServiceProvider)
        .applyFreezeIfNeeded(today: today, diaryMap: diaryMap);
    if (changed) {
      final newState = await _load();
      state = AsyncData(newState);
      AnalyticsService.logFreezeUsed(
        remainingFreezes: newState.freezesAvailable,
      );
    }
  }

  Future<void> recordWritingDay() async {
    await ref.read(freezeServiceProvider).recordWritingDay();
    state = AsyncData(await _load());
  }

  Future<void> restoreFreezesIfNeeded() async {
    final before = state.valueOrNull?.freezesAvailable;
    await ref.read(freezeServiceProvider).restoreFreezesIfNeeded();
    final newState = await _load();
    state = AsyncData(newState);
    if (before != null && newState.freezesAvailable > before) {
      AnalyticsService.logFreezeRestored();
    }
  }
}

final freezeProvider = AsyncNotifierProvider<FreezeNotifier, FreezeState>(
  FreezeNotifier.new,
);
