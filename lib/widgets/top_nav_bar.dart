import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../habit_provider.dart';
import '../theme/app_colors.dart';
import 'svg_asset.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onCalendarTap;
  final VoidCallback? onTutorialTap;

  const TopNavBar({
    super.key,
    required this.onCalendarTap,
    this.onTutorialTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.snow,
            border: Border(
              bottom: BorderSide(color: AppColors.swan, width: 2),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  // 1. Overall Perfect Days Streak Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.swan, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SvgAsset(
                          assetName: 'streak.svg',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${provider.overallPerfectStreak}',
                          style: const TextStyle(
                            fontFamily: 'DINRoundPro',
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.streakOrange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // 2. Streak Freezes Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.swan, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SvgAsset(
                          assetName: 'freezed.svg',
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${provider.streakFreezes}',
                          style: const TextStyle(
                            fontFamily: 'DINRoundPro',
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.eelBlue,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // 3. Tutorial / Info Button
                  if (onTutorialTap != null) ...[
                    GestureDetector(
                      onTap: onTutorialTap,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.snow,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.swan, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFD6D6D6),
                              offset: Offset(0, 3),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.help_outline_rounded,
                          color: AppColors.wolf,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // 4. Calendar & Progress Hub Button
                  GestureDetector(
                    onTap: onCalendarTap,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.snow,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.swan, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFD6D6D6),
                            offset: Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const SvgAsset(
                        assetName: 'calendarpageviewbutton.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
