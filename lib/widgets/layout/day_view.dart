import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/date_formatting.dart';

enum DayViewMode { streak, calendar }

class DayView extends StatelessWidget {
  final DateTime date;
  final DateTime today;
  final bool hasDiary;
  final VoidCallback onPress;
  final DayViewMode mode;

  const DayView({
    super.key,
    required this.date,
    required this.today,
    required this.hasDiary,
    required this.onPress,
    this.mode = DayViewMode.calendar,
  });

  bool get _isToday {
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (mode == DayViewMode.streak) {
      return _buildStreakDay(context, t, cs, textTheme);
    } else {
      return _buildCalendarDay(context, cs, textTheme);
    }
  }

  Widget _buildStreakDay(
      BuildContext context,
      AppLocalizations t,
      ColorScheme cs,
      TextTheme textTheme,
      ) {
    final label = getWeekday(date, t);

    Color bgColor;
    Color? iconColor;
    IconData? icon;

    if (hasDiary) {
      bgColor = cs.primary;
      iconColor = cs.onPrimary;
      icon = Icons.check_rounded;
    } else if (_isToday) {
      bgColor = cs.onPrimary;
      iconColor = cs.primary;
      icon = null;
    } else {
      bgColor = cs.inversePrimary;
      iconColor = null;
      icon = null;
    }

    return GestureDetector(
      onTap: onPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: _isToday && !hasDiary
                  ? Border.all(color: cs.primary, width: 1.5)
                  : Border.all(color: cs.outlineVariant.withOpacity(0.5), width: 0.5,)
            ),
            child: icon != null
                ? Icon(icon, color: iconColor, size: 18)
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: hasDiary
                  ? cs.onPrimaryContainer
                  : cs.onSurface.withOpacity(0.4),
              fontWeight:
              _isToday ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(
      BuildContext context,
      ColorScheme cs,
      TextTheme textTheme,
      ) {
    final isFuture = date.isAfter(today);

    Color bgColor;
    Color textColor;

    if (_isToday) {
      bgColor = cs.primary;
      textColor = cs.onPrimary;
    } else if (hasDiary) {
      bgColor = cs.primaryContainer.withOpacity(0.6);
      textColor = cs.onPrimaryContainer;
    } else {
      bgColor = Colors.transparent;
      textColor = cs.onSurface.withOpacity(0.4);
    }

    return GestureDetector(
      onTap: isFuture ? null : onPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: _isToday ? FontWeight.w700 : FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 3),
          if (hasDiary && !_isToday)
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(height: 4),
        ],
      ),
    );
  }
}