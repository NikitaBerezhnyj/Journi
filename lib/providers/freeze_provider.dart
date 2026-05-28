import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Future<FreezeState> build() async {
    return _load();
  }

  Future<FreezeState> _load() async {
    final service = ref.read(freezeServiceProvider);
    final available = await service.getFreezesAvailable();
    final usedDates = await service.getFreezeUsedDates();
    final daysWritten = await service.getDaysWrittenAfterFreeze();
    return FreezeState(
      freezesAvailable: available,
      freezeUsedDates: usedDates,
      daysWrittenAfterFreeze: daysWritten,
    );
  }

  Future<void> applyFreezeIfNeeded({
    required DateTime today,
    required Map<String, bool> diaryMap,
  }) async {
    final applied = await ref
        .read(freezeServiceProvider)
        .applyFreezeIfNeeded(today: today, diaryMap: diaryMap);
    if (applied > 0) {
      state = AsyncData(await _load());
    }
  }

  Future<void> recordWritingDay() async {
    await ref.read(freezeServiceProvider).recordWritingDay();
    state = AsyncData(await _load());
  }
}

final freezeProvider = AsyncNotifierProvider<FreezeNotifier, FreezeState>(
  FreezeNotifier.new,
);
