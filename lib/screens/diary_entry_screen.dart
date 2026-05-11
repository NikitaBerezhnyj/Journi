import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
  _SaveStatus _saveStatus = _SaveStatus.idle;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
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
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 800), () async {
      if (!mounted) return;

      setState(() => _saveStatus = _SaveStatus.saving);

      await ref.read(diaryEntryNotifierProvider.notifier).save(text);

      if (!mounted) return;
      setState(() => _saveStatus = _SaveStatus.saved);

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _saveStatus = _SaveStatus.idle);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppHeader(
        showBackButton: true,
        title: formatFullDate(widget.date, t),
        action: _buildSaveStatus(cs, theme),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: ref.watch(diaryEntryNotifierProvider).when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, _) => Center(child: Text('$e')),
                  data: (_) => TextField(
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
                      contentPadding: EdgeInsets.zero,
                    ),
                    autofocus: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Статус збереження замість кнопки
  Widget _buildSaveStatus(ColorScheme cs, ThemeData theme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (_saveStatus) {
        _SaveStatus.saving => Row(
          key: const ValueKey('saving'),
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: cs.onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Зберігається...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        _SaveStatus.saved => Row(
          key: const ValueKey('saved'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 16,
              color: cs.primary.withOpacity(0.7),
            ),
            const SizedBox(width: 6),
            Text(
              'Збережено',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        _SaveStatus.idle => const SizedBox(key: ValueKey('idle')),
      },
    );
  }
}