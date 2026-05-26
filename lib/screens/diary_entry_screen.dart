import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/diary_provider.dart';
import '../utils/date_formatting.dart';
import '../utils/diary_prompt_generator.dart';
import '../widgets/layout/app_header.dart';

enum _SaveStatus { idle, saving, saved }

class DiaryEntryScreen extends ConsumerStatefulWidget {
  final DateTime date;

  const DiaryEntryScreen({super.key, required this.date});

  @override
  ConsumerState<DiaryEntryScreen> createState() =>
      _DiaryEntryScreenState();
}

class _DiaryEntryScreenState extends ConsumerState<DiaryEntryScreen> {
  late final TextEditingController _controller;
  Timer? _debounce;
  Timer? _savedTimer;
  _SaveStatus _saveStatus = _SaveStatus.idle;
  bool _initialized = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();

    Future.microtask(() async {
      await ref
          .read(diaryEntryNotifierProvider.notifier)
          .loadForDate(widget.date);
      if (!mounted) return;
      final entry = ref.read(diaryEntryNotifierProvider).valueOrNull;
      if (entry != null && !_initialized) {
        _initialized = true;
        _controller.text = entry.text;
        _controller.selection = TextSelection.collapsed(
          offset: entry.text.length,
        );
        _focusNode.requestFocus();
      }
    });
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
    _debounce?.cancel();
    _savedTimer?.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      if (!mounted) return;

      setState(() => _saveStatus = _SaveStatus.saving);

      await ref.read(diaryEntryNotifierProvider.notifier).save(text);

      if (!mounted) return;

      setState(() => _saveStatus = _SaveStatus.saved);

      _savedTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _saveStatus = _SaveStatus.idle);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final entryAsync = ref.watch(diaryEntryNotifierProvider);
    final isLoading = entryAsync.isLoading;
    final hasError = entryAsync.hasError;

    return Scaffold(
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
                      textAlignVertical: TextAlignVertical.top,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: cs.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: DiaryPromptGenerator.getRandom(t),
                        hintStyle: TextStyle(
                          color: cs.onSurface.withOpacity(0.3),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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
    );
  }

  Widget _buildSaveStatus(ColorScheme cs, ThemeData theme, AppLocalizations t,) {
    return SizedBox(
      width: 125,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
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
                  color: cs.onSurface.withOpacity(0.4),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                t.saving,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withOpacity(0.4),
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
                color: cs.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Text(
                t.saved,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.primary.withOpacity(0.7),
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