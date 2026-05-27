class StreakDay {
  final DateTime date;
  final bool hasDiary;
  final bool isFrozen;

  StreakDay({
    required this.date,
    required this.hasDiary,
    this.isFrozen = false
  });
}