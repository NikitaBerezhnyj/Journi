import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journi/providers/time_service_provider.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  final Ref ref;

  AppLifecycleHandler(this.ref);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkDateChange();
    }
  }

  void _checkDateChange() {
    final timeService = ref.read(timeServiceProvider);
    final today = timeService.getToday();

    final current = ref.read(currentDateProvider);

    if (current != today) {
      ref.read(currentDateProvider.notifier).state = today;
    }
  }
}