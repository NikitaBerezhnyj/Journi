import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../screens/diary_entry_screen.dart';
import '../../types/streak_day.dart';
import '../../utils/date_formatting.dart';
import '../../utils/diary_utils.dart';
import 'day_view.dart';

class MonthView extends StatelessWidget {
  final DateTime month;
  final DateTime today;
  final Map<String, StreakDay> daysMap;

  const MonthView({
    super.key,
    required this.month,
    required this.today,
    required this.daysMap,
  });

  List<DateTime?> _buildCalendarDays(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth =
    DateUtils.getDaysInMonth(month.year, month.month);
    final offset = first.weekday - 1;
    return [
      ...List.filled(offset, null),
      ...List.generate(
        daysInMonth,
            (i) => DateTime(month.year, month.month, i + 1),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final days = _buildCalendarDays(month);

    final weekDays = List.generate(7, (index) {
      final date = DateTime(2024, 1, index + 1);
      return getWeekday(date, t);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 4),
            child: Text(
              formatMonth(month, t),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ),
          Row(
            children: weekDays.map((label) {
              return Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withOpacity(0.35),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.75,
              mainAxisSpacing: 4,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              if (date == null) return const SizedBox();
              final key =
              date.toIso8601String().substring(0, 10);
              final entry = daysMap[key];
              return DayView(
                date: date,
                today: today,
                hasDiary: entry?.hasDiary ?? false,
                isFrozen: entry?.isFrozen ?? false,
                mode: DayViewMode.calendar,
                onPress: () {
                  final hasDiary = entry?.hasDiary ?? false;

                  if (!canOpenDiary(
                    date: date,
                    today: today,
                    hasDiary: hasDiary,
                  )) {
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DiaryEntryScreen(date: date),
                    ),
                  );
                }
              );
            },
          ),
          const SizedBox(height: 8),
          Divider(
            color: cs.outlineVariant.withOpacity(0.4),
            height: 1,
          ),
        ],
      ),
    );
  }
}