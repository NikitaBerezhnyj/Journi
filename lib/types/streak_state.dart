import 'package:journi/types/streak_day.dart';

class StreakState {
  final int streakCount;
  final int freezesAvailable;
  final int daysWrittenAfterFreeze;
  final int daysToRestoreFreeze;
  final List<StreakDay> last7Days;

  StreakState({
    required this.streakCount,
    required this.freezesAvailable,
    required this.daysWrittenAfterFreeze,
    required this.daysToRestoreFreeze,
    required this.last7Days
  });

  int get daysUntilRestore =>
      freezesAvailable >= 2 ? 0 : daysToRestoreFreeze - daysWrittenAfterFreeze;

  bool get canRestoreFreeze => daysUntilRestore <= 0 && freezesAvailable < 2;

  static StreakState empty() => StreakState(
    streakCount: 0,
    freezesAvailable: 2,
    daysWrittenAfterFreeze: 0,
    daysToRestoreFreeze: 3,
    last7Days: [],
  );
}