import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../habit_provider.dart';
import '../theme/app_colors.dart';
import 'tactile_card.dart';
import 'svg_asset.dart';
import 'week_streak_modal.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({
    super.key,
    required this.habit,
  });

  String _formatDays(Set<int> days) {
    if (days.length == 7) return 'Everyday';
    final dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final sorted = days.toList()..sort();
    return sorted.map((d) => dayLetters[d - 1]).join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context, listen: false);
    final now = DateTime.now();
    final isCompleted = habit.isCompletedOn(now);
    final isRest = habit.isRestOn(now);
    final isFrozen = habit.isFrozenOn(now);

    return TactileCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      borderColor: isCompleted
          ? AppColors.owlGreen
          : (isRest ? const Color(0xFFBA68C8) : AppColors.swan),
      shadowColor: isCompleted
          ? AppColors.owlGreenDeep
          : const Color(0xFFD6D6D6),
      child: Row(
        children: [
          // 1. Habit Icon in Colorful Container
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Color(habit.colorHex).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color(habit.colorHex).withOpacity(0.4),
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: SvgAsset(
              assetName: '${habit.iconName}.svg',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 14),

          // 2. Habit Title & Streak Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  habit.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'DINRoundPro',
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isCompleted ? AppColors.owlGreenDeep : AppColors.eelBlack,
                    decoration: isCompleted ? TextDecoration.none : null,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Individual Habit Streak Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFFCC80), width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SvgAsset(
                            assetName: 'streak.svg',
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${habit.currentStreak} d',
                            style: const TextStyle(
                              fontFamily: 'DINRoundPro',
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.streakOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Days indicator
                    Flexible(
                      child: Text(
                        _formatDays(habit.scheduledWeekdays),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'DINRoundPro',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.wolf,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 3. Rest Day Action Button
          GestureDetector(
            onTap: () {
              provider.markHabitRest(habit.id, now);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isRest ? const Color(0xFFF3E5F5) : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isRest ? const Color(0xFFBA68C8) : AppColors.swan,
                  width: 2,
                ),
              ),
              child: Tooltip(
                message: isRest ? 'Rest Day Active' : 'Mark as Rest Day',
                child: SvgAsset(
                  assetName: 'restfortodaysworkout.svg',
                  width: 22,
                  height: 22,
                  color: isRest ? const Color(0xFF8E24AA) : AppColors.wolf,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 4. Main Checkmark Completion Button
          GestureDetector(
            onTap: () async {
              final wasChecked = await provider.toggleHabitCompletion(habit.id, now);
              if (wasChecked && context.mounted) {
                // Show dopamine boost week-view modal
                WeekStreakModal.show(context, habit);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.owlGreen
                    : (isFrozen ? const Color(0xFFE1F5FE) : AppColors.snow),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCompleted
                      ? AppColors.owlGreenDeep
                      : (isFrozen ? AppColors.eelBlue : AppColors.swan),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isCompleted
                        ? AppColors.owlGreenDeep
                        : const Color(0xFFD6D6D6),
                    offset: const Offset(0, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: isCompleted
                  ? const SvgAsset(
                      assetName: 'checked.svg',
                      width: 24,
                      height: 24,
                    )
                  : (isFrozen
                      ? const SvgAsset(
                          assetName: 'freezed.svg',
                          width: 22,
                          height: 22,
                        )
                      : const SvgAsset(
                          assetName: 'unchecked.svg',
                          width: 20,
                          height: 20,
                        )),
            ),
          ),
        ],
      ),
    );
  }
}
