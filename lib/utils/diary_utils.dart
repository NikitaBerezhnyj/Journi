bool canOpenDiary({
  required DateTime date,
  required DateTime today,
  required bool hasDiary,
}) {
  final isToday =
      date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;

  return hasDiary || isToday;
}