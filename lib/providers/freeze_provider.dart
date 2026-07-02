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
  Future<FreezeState> build() async => _load();

  FreezeState _load() {
    final service = ref.read(freezeServiceProvider);
    return FreezeState(
      freezesAvailable: service.getFreezesAvailable(),
      freezeUsedDates: service.getFreezeUsedDates(),
      daysWrittenAfterFreeze: service.getDaysWrittenAfterFreeze(),
    );
  }

  void applyFreezeIfNeeded({
    required DateTime today,
    required Map<String, bool> diaryMap,
  }) {
    final changed = ref
        .read(freezeServiceProvider)
        .applyFreezeIfNeeded(today: today, diaryMap: diaryMap);
    if (changed) {
      state = AsyncData(_load());
    }
  }

  void recordWritingDay() async {
    ref.read(freezeServiceProvider).recordWritingDay();
    state = AsyncData(_load());
  }
}

final freezeProvider = AsyncNotifierProvider<FreezeNotifier, FreezeState>(
  FreezeNotifier.new,
);
