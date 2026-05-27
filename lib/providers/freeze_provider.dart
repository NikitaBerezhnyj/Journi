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
    final available = await FreezeService.instance.getFreezesAvailable();
    final usedDates = await FreezeService.instance.getFreezeUsedDates();
    final daysWritten = await FreezeService.instance
        .getDaysWrittenAfterFreeze();
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
    final applied = await FreezeService.instance.applyFreezeIfNeeded(
      today: today,
      diaryMap: diaryMap,
    );
    if (applied > 0) {
      state = AsyncData(await _load());
    }
  }

  Future<void> recordWritingDay() async {
    await FreezeService.instance.recordWritingDay();
    state = AsyncData(await _load());
  }
}

final freezeProvider = AsyncNotifierProvider<FreezeNotifier, FreezeState>(
  FreezeNotifier.new,
);
