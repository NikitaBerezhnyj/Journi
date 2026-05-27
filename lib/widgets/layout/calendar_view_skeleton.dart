import 'package:flutter/material.dart';
import 'skeleton_widget.dart';

class CalendarViewSkeleton extends StatelessWidget {
  const CalendarViewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(2, (_) => _MonthSkeleton()),
    );
  }
}

class _MonthSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 120, height: 18, radius: 6),
          const SizedBox(height: 12),

          ...List.generate(
            5,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: List.generate(7, (i) => i).map((i) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: SkeletonBox(
                        width: double.infinity,
                        height: 36,
                        radius: 8,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
