import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';
import '../theme/app_colors.dart';
import 'svg_asset.dart';
import 'squishy_button.dart';

class WeekStreakModal extends StatefulWidget {
  final Habit habit;
  final VoidCallback onContinue;

  const WeekStreakModal({
    super.key,
    required this.habit,
    required this.onContinue,
  });

  static Future<void> show(BuildContext context, Habit habit) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WeekStreakModal(
        habit: habit,
        onContinue: () => Navigator.pop(context),
      ),
    );
  }

  @override
  State<WeekStreakModal> createState() => _WeekStreakModalState();
}

class _WeekStreakModalState extends State<WeekStreakModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _flameScale;

  @override
  void initState() {
    super.initState();
    HapticFeedback.mediumImpact();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    // Duolingo Back-Out spring overshoot curve: cubic-bezier(0.34, 1.56, 0.64, 1)
    _flameScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  List<DateTime> _getCurrentWeekDays() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  String _getSvgForDay(DateTime date) {
    final dayName = _getDayName(date.weekday);
    final dateStr = Habit.formatDate(date);

    if (widget.habit.completedDates.contains(dateStr)) {
      return '${dayName}checked.svg';
    } else if (widget.habit.frozenDates.contains(dateStr)) {
      return '${dayName}freezed.svg';
    } else {
      return '${dayName}unchecked.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _getCurrentWeekDays();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.snow,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border(
          top: BorderSide(color: AppColors.swan, width: 2),
          left: BorderSide(color: AppColors.swan, width: 2),
          right: BorderSide(color: AppColors.swan, width: 2),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.swan,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),

          // Flame Icon with Staggered Scale Animation & Glow
          ScaleTransition(
            scale: _flameScale,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.streakOrange.withOpacity(0.35),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: const SvgAsset(
                assetName: 'streak.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Streak Count
          Text(
            '${widget.habit.currentStreak} DAY STREAK!',
            style: const TextStyle(
              fontFamily: 'DINRoundPro',
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.streakOrange,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle
          Text(
            'You completed "${widget.habit.title}" for today!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'DINRoundPro',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.wolf,
            ),
          ),
          const SizedBox(height: 28),

          // 7-Day Streak Week View Row with GSAP-inspired staggered spring entrance
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.swan, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;
                final isToday = day.year == DateTime.now().year &&
                    day.month == DateTime.now().month &&
                    day.day == DateTime.now().day;
                final svgName = _getSvgForDay(day);

                // Staggered interval: start staggered after flame pops
                final double start = (0.2 + (index * 0.08)).clamp(0.0, 0.85);
                final double end = (start + 0.35).clamp(0.0, 1.0);
                final itemScale = Tween<double>(begin: 0.4, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animController,
                    curve: Interval(start, end, curve: Curves.easeOutBack),
                  ),
                );

                return ScaleTransition(
                  scale: itemScale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('E').format(day).substring(0, 1),
                        style: TextStyle(
                          fontFamily: 'DINRoundPro',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isToday ? AppColors.streakOrange : AppColors.wolf,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 38,
                        height: 38,
                        child: SvgAsset(
                          assetName: svgName,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 28),

          // Duolingo 3D Squishy Continue Button
          SizedBox(
            width: double.infinity,
            child: SquishyButton(
              backgroundColor: AppColors.owlGreen,
              shadowColor: AppColors.owlGreenDeep,
              onPressed: widget.onContinue,
              height: 56,
              child: const Text(
                'CONTINUE',
                style: TextStyle(
                  fontFamily: 'DINRoundPro',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
