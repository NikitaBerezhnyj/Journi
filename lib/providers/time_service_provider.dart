import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/time_service.dart';

final timeServiceProvider = Provider((ref) => TimeService());

final currentDateProvider = StateProvider<DateTime>((ref) {
  final timeService = ref.read(timeServiceProvider);
  return timeService.getToday();
});