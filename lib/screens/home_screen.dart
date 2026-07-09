import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journi/screens/settings_screen.dart';
import 'package:journi/widgets/core/app_header.dart';
import 'package:journi/widgets/diary/streak_view.dart';
import '../providers/diary_provider.dart';
import '../providers/freeze_provider.dart';
import '../providers/time_service_provider.dart';
import '../types/streak_day.dart';
import '../types/streak_state.dart';
import '../widgets/diary/calendar_view.dart';
import '../widgets/diary/calendar_view_skeleton.dart';
import '../widgets/diary/freeze_info_bottom_sheet.dart';
import '../widgets/diary/streak_view_skeleton.dart';
import 'diary_entry_screen.dart';
import 'freeze_intro_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  ProviderSubscription? _streakSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _streakSubscription = ref.listenManual(streakDaysMapProvider, (
        _,
        next,
      ) async {
        if (next is! AsyncData<Map<String, StreakDay>>) return;
        final diaryMap = next.value;
        final today = ref.read(currentDateProvider);

        final Map<String, bool> mapForFreeze = {
          for (final e in diaryMap.entries) e.key: e.value.hasDiary,
        };

        final streakIsZero = _computeStreakIsZero(diaryMap, today);
        if (streakIsZero) {
          await ref.read(freezeProvider.notifier).restoreFreezesIfNeeded();
        } else {
          await ref
              .read(freezeProvider.notifier)
              .applyFreezeIfNeeded(today: today, diaryMap: mapForFreeze);
        }

        ref.invalidate(freezeProvider);
      }, fireImmediately: true);
    });
  }

  @override
  void dispose() {
    _streakSubscription?.close();
    super.dispose();
  }

  bool _computeStreakIsZero(Map<String, StreakDay> diaryMap, DateTime today) {
    final todayKey = today.toIso8601String().substring(0, 10);
    final yesterdayKey = today
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);

    return !(diaryMap[todayKey]?.hasDiary == true ||
        diaryMap[yesterdayKey]?.hasDiary == true);
  }

  void _showFreezeBottomSheet(BuildContext context, StreakState state) {
    FreezeInfoBottomSheet.show(
      context,
      freezesAvailable: state.freezesAvailable,
      daysWrittenAfterFreeze: state.daysWrittenAfterFreeze,
      daysToRestore: state.daysToRestoreFreeze,
    );
  }

  Future<void> _openDiary(DateTime date) async {
    ref.invalidate(diaryEntryNotifierProvider(date));
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DiaryEntryScreen(date: date)),
    );
    ref.invalidate(allEntriesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = ref.watch(currentDateProvider);
    final streakAsync = ref.watch(streakStateProvider);
    final calendarAsync = ref.watch(calendarDaysProvider);

    final bothReady = streakAsync.hasValue && calendarAsync.hasValue;
    final hasError = streakAsync.hasError || calendarAsync.hasError;

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
            if (hasError)
              Text('Error: ${streakAsync.error ?? calendarAsync.error}')
            else if (!bothReady) ...[
              const StreakViewSkeleton(),
            ] else
              StreakView(
                streakState: streakAsync.value!,
                today: today,
                onFreezeTap: () =>
                    _showFreezeBottomSheet(context, streakAsync.value!),
                onDayTap: _openDiary,
              ),
            Expanded(
              child: !bothReady
                  ? const CalendarViewSkeleton()
                  : CalendarView(
                days: calendarAsync.value!,
                today: today,
                onDayTap: _openDiary,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _openDiary(DateTime.now());
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
