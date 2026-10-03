import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../habit_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/top_nav_bar.dart';
import '../widgets/habit_card.dart';
import '../widgets/task_card.dart';
import '../widgets/create_habit_modal.dart';
import '../widgets/create_task_modal.dart';
import '../widgets/svg_asset.dart';
import 'calendar_screen.dart';
import 'onboarding_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        final todayHabits = provider.todayHabits;
        final todayTasks = provider.todayTasks;
        final now = DateTime.now();

        return Scaffold(
          backgroundColor: AppColors.snow,
          // 1. Top Navigation Bar with Streaks, Freezes, Tutorial, and Calendar
          appBar: TopNavBar(
            onTutorialTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingScreen()),
              );
            },
            onCalendarTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarScreen()),
              );
            },
          ),
          // Notice: STRICTLY NO bottomNavigationBar!
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // 2. Greeting & Date Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, MMM d').format(now).toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'DINRoundPro',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.wolf,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Today's Quest",
                            style: TextStyle(
                              fontFamily: 'DINRoundPro',
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.eelBlack,
                            ),
                          ),
                        ],
                      ),
                      // Motivational flame or lightning
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.swan, width: 2),
                        ),
                        child: const SvgAsset(
                          assetName: 'lightning.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Habits Section Header with Add Action
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'HABITS',
                            style: TextStyle(
                              fontFamily: 'DINRoundPro',
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.wolf,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.owlGreenPale,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${todayHabits.length}',
                              style: const TextStyle(
                                fontFamily: 'DINRoundPro',
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.owlGreenDeep,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => CreateHabitModal.show(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.owlGreen,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.owlGreenDeep,
                                offset: Offset(0, 2),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'HABIT',
                                style: TextStyle(
                                  fontFamily: 'DINRoundPro',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Habits List or Empty Rest Day state
                if (todayHabits.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.swan, width: 2),
                      ),
                      child: Column(
                        children: [
                          const SvgAsset(assetName: 'homepage.svg', width: 64, height: 64),
                          const SizedBox(height: 14),
                          const Text(
                            'Enjoy Your Rest Day!',
                            style: TextStyle(
                              fontFamily: 'DINRoundPro',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.eelBlack,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'No habits scheduled for today. Your streak is completely safe and protected.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'DINRoundPro',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.wolf,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    children: todayHabits.map((habit) => HabitCard(habit: habit)).toList(),
                  ),

                const SizedBox(height: 28),

                // 4. Tasks Section Header with Add Action
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'DAILY TASKS',
                            style: TextStyle(
                              fontFamily: 'DINRoundPro',
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.wolf,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${todayTasks.length}',
                              style: const TextStyle(
                                fontFamily: 'DINRoundPro',
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.streakOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => CreateTaskModal.show(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.streakOrange,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.streakOrangeDeep,
                                offset: Offset(0, 2),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'TASK',
                                style: TextStyle(
                                  fontFamily: 'DINRoundPro',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Tasks List or Empty State
                if (todayTasks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.swan, width: 2),
                      ),
                      child: const Center(
                        child: Text(
                          'No pending tasks. Tap "+ TASK" to add one with a deadline!',
                          style: TextStyle(
                            fontFamily: 'DINRoundPro',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.wolf,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Column(
                    children: todayTasks.map((task) => TaskCard(task: task)).toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
