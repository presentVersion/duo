import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'habit_provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_colors.dart';

export 'screens/home_screen.dart';
export 'screens/onboarding_screen.dart';
export 'habit_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

  runApp(HabitTrackerApp(hasSeenOnboarding: hasSeenOnboarding));
}

class HabitTrackerApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const HabitTrackerApp({
    super.key,
    this.hasSeenOnboarding = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitProvider()),
      ],
      child: MaterialApp(
        title: 'Habit Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'DINRoundPro',
          scaffoldBackgroundColor: AppColors.snow,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.owlGreen,
            primary: AppColors.owlGreen,
            secondary: AppColors.eelBlue,
            tertiary: AppColors.streakOrange,
            surface: AppColors.snow,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.snow,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleTextStyle: TextStyle(
              fontFamily: 'DINRoundPro',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.eelBlack,
            ),
          ),
        ),
        home: hasSeenOnboarding ? const HomeScreen() : const OnboardingScreen(),
      ),
    );
  }
}
