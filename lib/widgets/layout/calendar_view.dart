import 'package:flutter/material.dart';

import '../../types/streak_day.dart';
import 'month_view.dart';

class CalendarView extends StatelessWidget {
  final Map<String, StreakDay> days;
  final DateTime today;

  const CalendarView({
    super.key,
    required this.days,
    required this.today
  });

  @override
  Widget build(BuildContext context) {
    final dates = days.keys.map((k) => DateTime.parse(k)).toList()..sort();
    final start = dates.isNotEmpty
        ? DateTime(dates.first.year, dates.first.month)
        : DateTime(DateTime.now().year, DateTime.now().month);
    final end = DateTime.now();

    final months = _generateMonths(start, end);

    return ListView.builder(
      itemCount: months.length,
      itemBuilder: (context, index) {
        return MonthView(
          month: months[index],
          today: today,
          daysMap: days,
        );
      },
    );
  }

  List<DateTime> _generateMonths(DateTime start, DateTime end) {
    final months = <DateTime>[];

    DateTime current = DateTime(end.year, end.month);

    while (!current.isBefore(start)) {
      months.add(current);
      current = DateTime(current.year, current.month - 1);
    }

    return months;
  }
}