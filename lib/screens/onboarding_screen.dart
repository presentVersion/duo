import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../widgets/squishy_button.dart';
import '../widgets/svg_asset.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'badge': 'WELCOME TO THE QUEST',
      'title': 'Dopamine-Driven Habit Tracking',
      'subtitle':
          'Built with Duolingo streak psychology. No boring checklists — gamify your daily discipline and watch your habits compound.',
      'imageType': 'png',
      'imagePath': 'assets/images/app_icon.png',
      'tagColor': AppColors.owlGreen,
      'bgGradient': [Color(0xFFE8F5E9), Color(0xFFFFFFFF)],
    },
    {
      'badge': 'THE FLAME ENGINE',
      'title': 'Master Perfect Day Streaks',
      'subtitle':
          'Your top bar flame counts your "Perfect Days". When 100% of your scheduled habits and tasks are fulfilled, your master streak lights up!',
      'imageType': 'svg',
      'imagePath': 'streak.svg',
      'secondarySvg': 'Trophy.svg',
      'tagColor': AppColors.streakOrange,
      'bgGradient': [Color(0xFFFFF3E0), Color(0xFFFFFFFF)],
    },
    {
      'badge': 'STRESS-FREE FLEXIBILITY',
      'title': 'Rest Days & Streak Freezes',
      'subtitle':
          'Rest days (workout recovery, scheduled breaks) protect your streak without penalty! Unexpected busy days are rescued by your ice-blue Streak Freezes.',
      'imageType': 'dual_svg',
      'svg1': 'restfortodaysworkout.svg',
      'svg2': 'freezed.svg',
      'tagColor': AppColors.eelBlue,
      'bgGradient': [Color(0xFFE1F5FE), Color(0xFFFFFFFF)],
    },
    {
      'badge': 'EPIC CELEBRATIONS',
      'title': 'Milestone Path & Rewards',
      'subtitle':
          'Unlock 10, 15, 20, 30, and 50-day milestones to watch celebratory animations, earn shiny golden chest trophies, and claim bonus streak freezes!',
      'imageType': 'svg',
      'imagePath': 'streakchamp.svg',
      'secondarySvg': 'goldenchestclosed.svg',
      'tagColor': AppColors.gemPink,
      'bgGradient': [Color(0xFFF3E5F5), Color(0xFFFFFFFF)],
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.snow,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Progress Dots
                  Row(
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 6),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.owlGreen : AppColors.swan,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Skip Action
                  TextButton(
                    onPressed: _completeOnboarding,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.wolf,
                    ),
                    child: const Text(
                      'SKIP',
                      style: TextStyle(
                        fontFamily: 'DINRoundPro',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page View Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration Container
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: page['bgGradient'] as List<Color>,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: AppColors.swan, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: (page['tagColor'] as Color).withOpacity(0.2),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: _buildPageIllustration(page),
                        ),
                        const SizedBox(height: 36),

                        // Pill Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: (page['tagColor'] as Color).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            page['badge'] as String,
                            style: TextStyle(
                              fontFamily: 'DINRoundPro',
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: page['tagColor'] as Color,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Title
                        Text(
                          page['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'DINRoundPro',
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.eelBlack,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          page['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'DINRoundPro',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.wolf,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Squishy Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: SizedBox(
                width: double.infinity,
                child: SquishyButton(
                  backgroundColor: AppColors.owlGreen,
                  shadowColor: AppColors.owlGreenDeep,
                  onPressed: _nextPage,
                  height: 56,
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? "LET'S BUILD HABITS!"
                        : 'CONTINUE',
                    style: const TextStyle(
                      fontFamily: 'DINRoundPro',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIllustration(Map<String, dynamic> page) {
    final type = page['imageType'] as String;

    if (type == 'png') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          page['imagePath'] as String,
          width: 170,
          height: 170,
          fit: BoxFit.cover,
        ),
      );
    } else if (type == 'dual_svg') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E5F5),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFBA68C8), width: 2),
            ),
            child: SvgAsset(
              assetName: page['svg1'] as String,
              width: 52,
              height: 52,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.eelBlue, width: 2),
            ),
            child: SvgAsset(
              assetName: page['svg2'] as String,
              width: 52,
              height: 52,
            ),
          ),
        ],
      );
    } else {
      return SvgAsset(
        assetName: page['imagePath'] as String,
        width: 120,
        height: 120,
      );
    }
  }
}
