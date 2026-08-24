import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/diary_provider.dart';
import '../services/analytics_service.dart';
import '../utils/date_utils.dart';
import '../utils/diary_prompt_generator.dart';
import '../widgets/core/app_header.dart';

enum _SaveStatus { idle, saving, saved }

class DiaryEntryScreen extends ConsumerStatefulWidget {
  final DateTime date;

  const DiaryEntryScreen({super.key, required this.date});

  @override
  ConsumerState<DiaryEntryScreen> createState() => _DiaryEntryScreenState();
}

class _DiaryEntryScreenState extends ConsumerState<DiaryEntryScreen> {
  late final TextEditingController _controller;
  Timer? _debounce;
  Timer? _savedTimer;
  _SaveStatus _saveStatus = _SaveStatus.idle;
  bool _initialized = false;
  late final FocusNode _focusNode;

  String _initialText = '';
  bool _startedLogged = false;

  bool get _isToday => DateUtils.isSameDay(widget.date, DateTime.now());

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _savedTimer?.cancel();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (!_startedLogged && _initialText.isEmpty && text.trim().isNotEmpty) {
      _startedLogged = true;
      AnalyticsService.logEntryStarted(isToday: _isToday);
    }

    _debounce?.cancel();
    _savedTimer?.cancel();

    if (_saveStatus != _SaveStatus.idle) {
      setState(() => _saveStatus = _SaveStatus.idle);
    }

    _debounce = Timer(const Duration(milliseconds: 700), () async {
      if (!mounted) return;

      final startedAt = DateTime.now();

      setState(() => _saveStatus = _SaveStatus.saving);

      await ref
          .read(diaryEntryNotifierProvider(widget.date).notifier)
          .save(text);

      const minSavingDuration = Duration(milliseconds: 250);

      final elapsed = DateTime.now().difference(startedAt);

      if (elapsed < minSavingDuration) {
        await Future.delayed(minSavingDuration - elapsed);
      }

      if (!mounted) return;

      setState(() => _saveStatus = _SaveStatus.saved);

      _savedTimer = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _saveStatus = _SaveStatus.idle);
        }
      });
    });
  }

  Future<void> _flushAndLogOnExit() async {
    _debounce?.cancel();
    _savedTimer?.cancel();
    final finalText = _controller.text;
    await ref
        .read(diaryEntryNotifierProvider(widget.date).notifier)
        .save(finalText);

    final trimmedFinal = finalText.trim();
    final hadPreviousText = _initialText.trim().isNotEmpty;

    if (trimmedFinal.isEmpty) {
      if (hadPreviousText || _startedLogged) {
        AnalyticsService.logEntryAbandoned(
          isToday: _isToday,
          hadPreviousText: hadPreviousText,
        );
      }
    } else if (trimmedFinal != _initialText.trim()) {
      AnalyticsService.logEntrySaved(
        finalLength: finalText.length,
        isToday: _isToday,
        isEdit: hadPreviousText,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    ref.listen(diaryEntryNotifierProvider(widget.date), (_, next) {
      final entry = next.valueOrNull;
      if (entry != null && !_initialized) {
        _initialized = true;
        _initialText = entry.text;
        _controller.text = entry.text;
        _controller.selection = TextSelection.collapsed(
          offset: entry.text.length,
        );
        _focusNode.requestFocus();
      }
    });

    final entryAsync = ref.watch(diaryEntryNotifierProvider(widget.date));
    final isLoading = entryAsync.isLoading;
    final hasError = entryAsync.hasError;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _flushAndLogOnExit();
        if (context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppHeader(
          showBackButton: true,
          title: formatFullDate(widget.date, t),
          action: _buildSaveStatus(cs, theme, t),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: Stack(
                    children: [
                      TextField(
                        focusNode: _focusNode,
                        controller: _controller,
                        onChanged: _onTextChanged,
                        maxLines: null,
                        expands: true,
                        textCapitalization: TextCapitalization.sentences,
                        textAlignVertical: TextAlignVertical.top,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: cs.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: DiaryPromptGenerator.getRandom(t),
                          hintStyle: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.3),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.fromLTRB(
                            0,
                            0,
                            0,
                            20,
                          ),
                        ),
                      ),
                      if (isLoading)
                        const Center(child: CircularProgressIndicator()),
                      if (hasError)
                        Center(
                          child: Text(
                            '${entryAsync.error}',
                            style: TextStyle(color: cs.error),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveStatus(ColorScheme cs, ThemeData theme, AppLocalizations t) {
    return SizedBox(
      width: 125,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: switch (_saveStatus) {
          _SaveStatus.saving => Row(
            key: const ValueKey('saving'),
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                t.saving,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          _SaveStatus.saved => Row(
            key: const ValueKey('saved'),
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 16,
                color: cs.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Text(
                t.saved,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.primary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          _SaveStatus.idle => const SizedBox.shrink(key: ValueKey('idle')),
        },
      ),
    );
  }
}
