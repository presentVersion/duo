import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../habit_provider.dart';
import '../models/habit.dart';
import '../theme/app_colors.dart';
import '../widgets/svg_asset.dart';
import '../widgets/tactile_card.dart';
import '../widgets/video_celebration_dialog.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  String _selectedViewId = 'perfect_days'; // 'perfect_days' or habit.id
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        Habit? selectedHabit;
        if (_selectedViewId != 'perfect_days') {
          try {
            selectedHabit = provider.habits.firstWhere((h) => h.id == _selectedViewId);
          } catch (_) {
            _selectedViewId = 'perfect_days';
          }
        }

        return Scaffold(
          backgroundColor: AppColors.snow,
          appBar: AppBar(
            backgroundColor: AppColors.snow,
            elevation: 0,
            leading: IconButton(
              icon: const SvgAsset(assetName: 'back.svg', width: 22, height: 22),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Progress & Streaks',
              style: TextStyle(
                fontFamily: 'DINRoundPro',
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.eelBlack,
              ),
            ),
            centerTitle: true,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(2),
              child: Divider(color: AppColors.swan, height: 2, thickness: 2),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // 1. Top Stat Cards (Horizontal scroll)
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Perfect Days Stat
                      _buildStatCard(
                        icon: 'Trophy.svg',
                        value: '${provider.overallPerfectStreak}',
                        label: 'Perfect Streak',
                        color: AppColors.streakOrange,
                        bgColor: const Color(0xFFFFF3E0),
                      ),
                      const SizedBox(width: 12),

                      // Longest Streak Stat
                      _buildStatCard(
                        icon: 'streakchamp.svg',
                        value: '${provider.bestOverallStreak}',
                        label: 'Best Streak',
                        color: AppColors.owlGreen,
                        bgColor: AppColors.owlGreenPale,
                      ),
                      const SizedBox(width: 12),

                      // Streak Freezes Stat
                      _buildStatCard(
                        icon: 'freezed.svg',
                        value: '${provider.streakFreezes}',
                        label: 'Freezes Left',
                        color: AppColors.eelBlue,
                        bgColor: const Color(0xFFE0F2FE),
                      ),
                      const SizedBox(width: 12),

                      // Active Habits Stat
                      _buildStatCard(
                        icon: 'Goals.svg',
                        value: '${provider.habits.length}',
                        label: 'Total Habits',
                        color: AppColors.gemPink,
                        bgColor: const Color(0xFFF3E8FF),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Calendar View Dropdown Selector
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.swan, width: 2),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedViewId,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.eelBlack, size: 28),
                        style: const TextStyle(
                          fontFamily: 'DINRoundPro',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.eelBlack,
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: 'perfect_days',
                            child: Row(
                              children: [
                                SvgAsset(assetName: 'streak.svg', width: 20, height: 20),
                                SizedBox(width: 10),
                                Text('⭐ Perfect Days Streak'),
                              ],
                            ),
                          ),
                          ...provider.habits.map((habit) {
                            return DropdownMenuItem(
                              value: habit.id,
                              child: Row(
                                children: [
                                  SvgAsset(assetName: '${habit.iconName}.svg', width: 20, height: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      habit.title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedViewId = val);
                          }
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Monthly Duolingo Calendar View
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TactileCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        TableCalendar(
                          firstDay: DateTime.now().subtract(const Duration(days: 365)),
                          lastDay: DateTime.now().add(const Duration(days: 365)),
                          focusedDay: _focusedDay,
                          calendarFormat: CalendarFormat.month,
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                              fontFamily: 'DINRoundPro',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.eelBlack,
                            ),
                          ),
                          calendarStyle: const CalendarStyle(
                            outsideDaysVisible: false,
                          ),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              return _buildCalendarDayCell(context, provider, day, selectedHabit);
                            },
                            todayBuilder: (context, day, focusedDay) {
                              return _buildCalendarDayCell(context, provider, day, selectedHabit, isToday: true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 4. Milestone Path Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const SvgAsset(assetName: 'streakchamp.svg', width: 26, height: 26),
                      const SizedBox(width: 10),
                      const Text(
                        'Milestone Path',
                        style: TextStyle(
                          fontFamily: 'DINRoundPro',
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.eelBlack,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${provider.overallPerfectStreak} Days Active',
                        style: const TextStyle(
                          fontFamily: 'DINRoundPro',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.streakOrange,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 5. Staggered Milestone Path Nodes
                _buildMilestonePath(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String value,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SvgAsset(assetName: icon, width: 22, height: 22),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'DINRoundPro',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'DINRoundPro',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.wolf,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDayCell(
    BuildContext context,
    HabitProvider provider,
    DateTime day,
    Habit? habit, {
    bool isToday = false,
  }) {
    final dateStr = Habit.formatDate(day);
    bool isCompleted = false;
    bool isRest = false;
    bool isFrozen = false;

    if (habit != null) {
      isCompleted = habit.completedDates.contains(dateStr);
      isRest = habit.restDates.contains(dateStr);
      isFrozen = habit.frozenDates.contains(dateStr);
    } else {
      // Perfect Day mode
      isCompleted = provider.isPerfectDay(day);
    }

    Color cellColor = Colors.transparent;
    Color textColor = AppColors.eelBlack;
    Widget? iconOverlay;

    if (isCompleted) {
      cellColor = AppColors.owlGreen;
      textColor = Colors.white;
      iconOverlay = const Positioned(
        bottom: 2,
        child: Icon(Icons.check, size: 10, color: Colors.white),
      );
    } else if (isRest) {
      cellColor = const Color(0xFFBA68C8);
      textColor = Colors.white;
      iconOverlay = const Positioned(
        bottom: 2,
        child: SvgAsset(assetName: 'restfortodaysworkout.svg', width: 12, height: 12, color: Colors.white),
      );
    } else if (isFrozen) {
      cellColor = AppColors.eelBlue;
      textColor = Colors.white;
      iconOverlay = const Positioned(
        bottom: 2,
        child: SvgAsset(assetName: 'freezed.svg', width: 12, height: 12, color: Colors.white),
      );
    }

    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: cellColor,
        shape: BoxShape.circle,
        border: isToday
            ? Border.all(color: AppColors.streakOrange, width: 2)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              fontFamily: 'DINRoundPro',
              fontSize: 14,
              fontWeight: isCompleted || isToday ? FontWeight.w900 : FontWeight.w600,
              color: textColor,
            ),
          ),
          if (iconOverlay != null) iconOverlay,
        ],
      ),
    );
  }

  Widget _buildMilestonePath(BuildContext context, HabitProvider provider) {
    final currentStreak = provider.overallPerfectStreak;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: provider.milestones.asMap().entries.map((entry) {
          final index = entry.key;
          final milestone = entry.value;
          final isUnlocked = currentStreak >= milestone.targetDays;
          final isClaimed = milestone.isClaimed;

          // Alternate left, center, right
          Alignment alignment;
          if (index % 3 == 0) {
            alignment = Alignment.centerLeft;
          } else if (index % 3 == 1) {
            alignment = Alignment.center;
          } else {
            alignment = Alignment.centerRight;
          }

          return Column(
            children: [
              Align(
                alignment: alignment,
                child: GestureDetector(
                  onTap: () {
                    if (isUnlocked && !isClaimed) {
                      VideoCelebrationDialog.show(
                        context,
                        milestone: milestone,
                        onClaim: () {
                          provider.claimMilestone(milestone.targetDays);
                        },
                      );
                    }
                  },
                  child: isUnlocked && !isClaimed
                      ? ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            width: 86,
                            height: 86,
                            decoration: BoxDecoration(
                              color: AppColors.owlGreenPale,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.owlGreen,
                                width: 3.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.owlGreen.withOpacity(0.4),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgAsset(
                                  assetName: milestone.iconAsset,
                                  width: 44,
                                  height: 44,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            color: isUnlocked
                                ? const Color(0xFFFFF7ED)
                                : AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isUnlocked
                                  ? AppColors.streakOrange
                                  : AppColors.swan,
                              width: 3.5,
                            ),
                            boxShadow: isUnlocked
                                ? [
                                    BoxShadow(
                                      color: AppColors.streakOrange.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgAsset(
                                assetName: milestone.iconAsset,
                                width: 44,
                                height: 44,
                                color: isUnlocked ? null : AppColors.hare,
                              ),
                              if (isClaimed)
                                const Positioned(
                                  bottom: 6,
                                  right: 6,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppColors.owlGreen,
                                    child: Icon(Icons.check, size: 14, color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: alignment,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.swan, width: 1.5),
                  ),
                  child: Text(
                    '${milestone.targetDays} Days: ${milestone.title}',
                    style: TextStyle(
                      fontFamily: 'DINRoundPro',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isUnlocked ? AppColors.eelBlack : AppColors.hare,
                    ),
                  ),
                ),
              ),
              if (index < provider.milestones.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    width: 4,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isUnlocked ? AppColors.owlGreenLight : AppColors.swan,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
