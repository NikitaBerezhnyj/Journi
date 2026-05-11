import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journi/screens/settings_screen.dart';
import 'package:journi/widgets/layout/app_header.dart';
import 'package:journi/widgets/layout/streak_view.dart';
import '../providers/diary_provider.dart';
import '../providers/time_service_provider.dart';
import '../widgets/layout/calendar_view.dart';
import '../widgets/layout/calendar_view_skeleton.dart';
import '../widgets/layout/streak_view_skeleton.dart';
import 'diary_entry_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}): super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final today = ref.watch(currentDateProvider);

    final last7DaysAsync = ref.watch(last7DaysProvider);
    final streakCountAsync = ref.watch(streakCountProvider);
    final allEntriesAsync = ref.watch(streakDaysMapProvider);

    return Scaffold(
      appBar: AppHeader(
                showSettingsButton: true,
                onSettings: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                )
            ),
      body: SafeArea(
        child: Column(
          children: [
            last7DaysAsync.when(
              data: (last7Days) => streakCountAsync.when(
                data: (count) => StreakView(
                  streak: last7Days,
                  streakCount: count,
                  today: today,
                ),
                loading: () => const StreakViewSkeleton(),
                error: (e, _) => Text('Error: $e'),
              ),
              loading: () => const StreakViewSkeleton(),
              error: (e, _) => Text('Error: $e'),
            ),

            Expanded(
              child: allEntriesAsync.when(
                data: (map) => CalendarView(days: map, today: today,),
                loading: () => const CalendarViewSkeleton(),
                error: (e, _) => Text('Error: $e'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DiaryEntryScreen(date: DateTime.now()),
            ),
          );
          ref.invalidate(allEntriesProvider);
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.edit_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}