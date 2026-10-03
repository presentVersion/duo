import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/main.dart' as app;

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'has_seen_onboarding': true,
    });
  });

  testWidgets('Habit Tracker smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const app.HabitTrackerApp(hasSeenOnboarding: true));
    await tester.pumpAndSettle();

    // Verify that HomeScreen is displayed when onboarding is completed.
    expect(find.byType(app.HomeScreen), findsOneWidget);
  });
}
