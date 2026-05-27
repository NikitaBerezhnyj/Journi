import 'package:flutter/material.dart';

class FreezeInfoBottomSheet extends StatelessWidget {
  final int freezesAvailable;
  final int daysWrittenAfterFreeze;
  final int daysToRestore;

  const FreezeInfoBottomSheet({
    super.key,
    required this.freezesAvailable,
    required this.daysWrittenAfterFreeze,
    required this.daysToRestore,
  });

  static void show(
    BuildContext context, {
    required int freezesAvailable,
    required int daysWrittenAfterFreeze,
    required int daysToRestore,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => FreezeInfoBottomSheet(
        freezesAvailable: freezesAvailable,
        daysWrittenAfterFreeze: daysWrittenAfterFreeze,
        daysToRestore: daysToRestore,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final daysLeft = daysToRestore - daysWrittenAfterFreeze;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Icon(Icons.ac_unit_rounded, color: cs.primary, size: 24),
              const SizedBox(width: 10),
              Text(
                'Заморозки streak',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _StatusRow(
            label: 'Доступно зараз',
            value: '$freezesAvailable з 2',
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 8),

          if (freezesAvailable < 2) ...[
            _StatusRow(
              label: 'До відновлення наступної',
              value: '$daysLeft ${_daysWord(daysLeft)}',
              cs: cs,
              theme: theme,
            ),
            const SizedBox(height: 8),
          ],

          const SizedBox(height: 8),
          Divider(color: cs.outlineVariant.withOpacity(0.4)),
          const SizedBox(height: 12),

          _InfoItem(
            icon: Icons.shield_outlined,
            text:
                'Якщо пропустиш день — заморозка автоматично захистить твій streak.',
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 10),
          _InfoItem(
            icon: Icons.replay_rounded,
            text:
                'Щоб відновити одну заморозку — пиши $daysToRestore дні поспіль.',
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 10),
          _InfoItem(
            icon: Icons.warning_amber_rounded,
            text: 'Якщо заморозок немає і день пропущено — streak згорає.',
            cs: cs,
            theme: theme,
          ),
        ],
      ),
    );
  }

  String _daysWord(int n) {
    if (n == 1) return 'дня';
    return 'днів';
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;
  final ThemeData theme;

  const _StatusRow({
    required this.label,
    required this.value,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final ColorScheme cs;
  final ThemeData theme;

  const _InfoItem({
    required this.icon,
    required this.text,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: cs.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
