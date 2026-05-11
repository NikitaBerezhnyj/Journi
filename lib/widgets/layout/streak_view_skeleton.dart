import 'package:flutter/material.dart';
import 'skeleton_widget.dart';

class StreakViewSkeleton extends StatelessWidget {
  const StreakViewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Card(
        elevation: 0,
        color: cs.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Рядок з вогником і числом
              Row(
                children: [
                  SkeletonBox(width: 28, height: 28, radius: 6),
                  const SizedBox(width: 10),
                  SkeletonBox(width: 48, height: 32, radius: 8),
                  const SizedBox(width: 8),
                  SkeletonBox(width: 80, height: 16, radius: 6),
                ],
              ),
              const SizedBox(height: 16),
              // 7 днів
              Row(
                children: List.generate(7, (i) => i).map((i) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SkeletonBox(
                        width: double.infinity,
                        height: 52,
                        radius: 10,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}