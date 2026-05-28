import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journi/screens/settings_screen.dart';
import 'package:journi/widgets/layout/app_header.dart';
import 'package:journi/widgets/layout/streak_view.dart';
import '../providers/diary_provider.dart';
import '../providers/freeze_provider.dart';
import '../providers/time_service_provider.dart';
import '../types/streak_state.dart';
import '../widgets/layout/calendar_view.dart';
import '../widgets/layout/calendar_view_skeleton.dart';
import '../widgets/layout/freeze_info_bottom_sheet.dart';
import '../widgets/layout/streak_view_skeleton.dart';
import 'diary_entry_screen.dart';
import 'freeze_intro_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(streakDaysMapProvider, (_, next) async {
        final diaryMap = next.valueOrNull;
        if (diaryMap == null) return;
        final today = ref.read(currentDateProvider);
        await ref
            .read(freezeProvider.notifier)
            .applyFreezeIfNeeded(
              today: today,
              diaryMap: {
                for (final e in diaryMap.entries) e.key: e.value.hasDiary,
              },
            );
      }, fireImmediately: true);
    });
  }

  void _showFreezeBottomSheet(BuildContext context, StreakState state) {
    FreezeInfoBottomSheet.show(
      context,
      freezesAvailable: state.freezesAvailable,
      daysWrittenAfterFreeze: state.daysWrittenAfterFreeze,
      daysToRestore: state.daysToRestoreFreeze,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = ref.watch(currentDateProvider);
    final streakAsync = ref.watch(streakStateProvider);
    final calendarAsync = ref.watch(calendarDaysProvider);

    return Scaffold(
      appBar: AppHeader(
        showSettingsButton: true,
        onSettings: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            streakAsync.when(
              data: (state) => StreakView(
                streakState: state,
                today: today,
                onFreezeTap: () => _showFreezeBottomSheet(context, state),
              ),
              loading: () => const StreakViewSkeleton(),
              error: (e, _) => Text('Error: $e'),
            ),
            Expanded(
              child: calendarAsync.when(
                data: (map) => CalendarView(days: map, today: today),
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
          if (!mounted) return;
          final shouldShow = await FreezeIntroScreen.shouldShow();
          if (!mounted) return;
          if (shouldShow) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FreezeIntroScreen()),
            );
          }
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.edit_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
