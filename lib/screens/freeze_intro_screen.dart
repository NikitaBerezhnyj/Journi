import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreezeIntroScreen extends StatelessWidget {
  const FreezeIntroScreen({super.key});

  static const _key = 'freeze_hint_seen';

  static Future<bool> shouldShow() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_key) ?? false);
  }

  static Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.ac_unit_rounded, size: 48, color: cs.primary),
              ),
              const SizedBox(height: 32),

              Text(
                'Заморозки захищають твій streak',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Іноді буває форс-мажор. Тому у тебе є 2 заморозки — вони не дадуть streak згоріти якщо пропустиш день.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurface.withOpacity(0.65),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              _RuleItem(
                icon: Icons.shield_outlined,
                color: cs.primary,
                text: 'Пропустив день — заморозка спрацьовує автоматично.',
                theme: theme,
                cs: cs,
              ),
              const SizedBox(height: 16),
              _RuleItem(
                icon: Icons.replay_rounded,
                color: cs.primary,
                text: 'Пиши 3 дні поспіль — отримаєш одну заморозку назад.',
                theme: theme,
                cs: cs,
              ),
              const SizedBox(height: 16),
              _RuleItem(
                icon: Icons.local_fire_department_rounded,
                color: cs.error,
                text: 'Якщо заморозок немає і день пропущено — streak згорає.',
                theme: theme,
                cs: cs,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await markSeen();
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Зрозуміло',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final ThemeData theme;
  final ColorScheme cs;

  const _RuleItem({
    required this.icon,
    required this.color,
    required this.text,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withOpacity(0.8),
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
