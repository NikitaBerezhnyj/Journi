import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../screens/diary_entry_screen.dart';
import '../../types/streak_day.dart';
import '../../utils/diary_utils.dart';
import 'day_view.dart';

class StreakView extends StatelessWidget {
  final List<StreakDay> streak;
  final int streakCount;
  final DateTime today;

  const StreakView({
    super.key,
    required this.streak,
    required this.streakCount,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Card(
        elevation: 0,
        color: cs.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    color: cs.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$streakCount',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    t.days_in_row,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onPrimaryContainer.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: streak.map((day) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: DayView(
                        date: day.date,
                        today: today,
                        hasDiary: day.hasDiary,
                        onPress: () {
                          if (!canOpenDiary(
                            date: day.date,
                            today: today,
                            hasDiary: day.hasDiary,
                          )) {
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DiaryEntryScreen(date: day.date),
                            ),
                          );
                        },
                        mode: DayViewMode.streak,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}