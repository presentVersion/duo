import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../habit_provider.dart';
import '../theme/app_colors.dart';
import 'tactile_card.dart';
import 'svg_asset.dart';

class TaskCard extends StatelessWidget {
  final DailyTask task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context, listen: false);
    final isDueToday = task.isDueToday;
    final isOverdue = task.isOverdue;

    Color deadlineColor = AppColors.wolf;
    if (isOverdue) {
      deadlineColor = AppColors.cardinalRed;
    } else if (isDueToday) {
      deadlineColor = AppColors.streakOrange;
    }

    return TactileCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 16,
      borderColor: task.isCompleted ? AppColors.owlGreenPale : AppColors.swan,
      child: Row(
        children: [
          // Checkbox Button
          GestureDetector(
            onTap: () => provider.toggleTask(task.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: task.isCompleted ? AppColors.owlGreen : AppColors.snow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: task.isCompleted ? AppColors.owlGreenDeep : AppColors.swan,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: task.isCompleted
                        ? AppColors.owlGreenDeep
                        : const Color(0xFFE0E0E0),
                    offset: const Offset(0, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: task.isCompleted
                  ? const SvgAsset(
                      assetName: 'checked.svg',
                      width: 18,
                      height: 18,
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 14),

          // Title & Due Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontFamily: 'DINRoundPro',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: task.isCompleted ? AppColors.hare : AppColors.eelBlack,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: deadlineColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Deadline: ${DateFormat('MMM d').format(task.dueDate)}',
                      style: TextStyle(
                        fontFamily: 'DINRoundPro',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: deadlineColor,
                      ),
                    ),
                    if (isOverdue) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'OVERDUE',
                          style: TextStyle(
                            fontFamily: 'DINRoundPro',
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.cardinalRed,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Delete Action
          IconButton(
            icon: const SvgAsset(
              assetName: 'delete.svg',
              width: 18,
              height: 18,
              color: AppColors.hare,
            ),
            onPressed: () => provider.deleteTask(task.id),
          ),
        ],
      ),
    );
  }
}
