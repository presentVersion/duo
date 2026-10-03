import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'models/habit.dart';
import 'models/task.dart';
import 'models/milestone.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];
  List<DailyTask> _tasks = [];
  int _streakFreezes = 3; // Initial starting inventory
  int _overallPerfectStreak = 0;
  int _bestOverallStreak = 0;
  bool _isLoaded = false;

  List<Milestone> _milestones = [
    Milestone(
      targetDays: 10,
      title: '10-Day Starter Streak',
      description: 'Maintained your habits for 10 consecutive days!',
      rewardFreezes: 1,
      videoAsset: 'assets/videos/Animation1.mp4',
      iconAsset: 'assets/images/10_day_streak.svg',
    ),
    Milestone(
      targetDays: 15,
      title: '15-Day Momentum',
      description: 'Two full weeks and beyond of pure discipline.',
      rewardFreezes: 1,
      videoAsset: 'assets/videos/Animation2.mp4',
      iconAsset: 'assets/images/Icon=Shiny Gold Chest, Size=Small.svg',
    ),
    Milestone(
      targetDays: 20,
      title: '20-Day Golden Chest',
      description: 'Unlock the mythical golden chest of habits!',
      rewardFreezes: 2,
      videoAsset: 'assets/videos/Animation2.mp4',
      iconAsset: 'assets/images/goldenchestclosed.svg',
    ),
    Milestone(
      targetDays: 30,
      title: '30-Day Streak Champion',
      description: 'A full month of relentless consistency!',
      rewardFreezes: 2,
      videoAsset: 'assets/videos/Animation3.mp4',
      iconAsset: 'assets/images/streakchamp.svg',
    ),
    Milestone(
      targetDays: 50,
      title: '50-Day Grand Trophy',
      description: 'The golden hall of fame achievement.',
      rewardFreezes: 3,
      videoAsset: 'assets/videos/Animation3.mp4',
      iconAsset: 'assets/images/Trophy.svg',
    ),
  ];

  HabitProvider() {
    _initData();
  }

  // Getters
  List<Habit> get habits => _habits;
  List<DailyTask> get tasks => _tasks;
  int get streakFreezes => _streakFreezes;
  int get overallPerfectStreak => _overallPerfectStreak;
  int get bestOverallStreak => _bestOverallStreak;
  List<Milestone> get milestones => _milestones;
  bool get isLoaded => _isLoaded;

  // Filtered habits for today
  List<Habit> get todayHabits {
    final now = DateTime.now();
    return _habits.where((h) => h.isScheduledFor(now)).toList();
  }

  // Tasks for today or overdue
  List<DailyTask> get todayTasks {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _tasks.where((t) {
      final taskDue = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
      return taskDue.isAtSameMomentAs(today) || (taskDue.isBefore(today) && !t.isCompleted);
    }).toList();
  }

  Future<void> _initData() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getString('habits_data');
    final tasksJson = prefs.getString('tasks_data');
    final milestonesJson = prefs.getString('milestones_data');
    _streakFreezes = prefs.getInt('streak_freezes') ?? 3;
    _bestOverallStreak = prefs.getInt('best_overall_streak') ?? 0;

    if (habitsJson != null) {
      final List<dynamic> decoded = jsonDecode(habitsJson);
      _habits = decoded.map((e) => Habit.fromJson(e)).toList();
    } else {
      _seedDefaultHabits();
    }

    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson);
      _tasks = decoded.map((e) => DailyTask.fromJson(e)).toList();
    } else {
      _seedDefaultTasks();
    }

    if (milestonesJson != null) {
      final List<dynamic> decoded = jsonDecode(milestonesJson);
      _milestones = decoded.map((e) => Milestone.fromJson(e)).toList();
    }

    _recalculateAllStreaks();
    _isLoaded = true;
    notifyListeners();
  }

  void _seedDefaultHabits() {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final yesterdayStr = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));
    final dayBeforeStr = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 2)));

    _habits = [
      Habit(
        id: const Uuid().v4(),
        title: 'Gym & Core Workout',
        iconName: 'Weights',
        colorHex: 0xFF58CC02,
        scheduledWeekdays: {1, 2, 3, 4, 5},
        completedDates: {yesterdayStr, dayBeforeStr},
        restDates: {},
      ),
      Habit(
        id: const Uuid().v4(),
        title: 'Read 20 Pages',
        iconName: 'readbook',
        colorHex: 0xFFFF9600,
        scheduledWeekdays: {1, 2, 3, 4, 5, 6, 7},
        completedDates: {yesterdayStr, dayBeforeStr},
        restDates: {},
      ),
      Habit(
        id: const Uuid().v4(),
        title: 'Hydrate 3L Water',
        iconName: 'lightning',
        colorHex: 0xFF1CB0F6,
        scheduledWeekdays: {1, 2, 3, 4, 5, 6, 7},
        completedDates: {yesterdayStr, dayBeforeStr, todayStr},
        restDates: {},
      ),
    ];
  }

  void _seedDefaultTasks() {
    final now = DateTime.now();
    _tasks = [
      DailyTask(
        id: const Uuid().v4(),
        title: 'Review weekly progress report',
        dueDate: now,
        isCompleted: false,
      ),
      DailyTask(
        id: const Uuid().v4(),
        title: 'Plan next month goals & milestones',
        dueDate: now.add(const Duration(days: 3)),
        isCompleted: false,
      ),
    ];
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = jsonEncode(_habits.map((e) => e.toJson()).toList());
    final tasksJson = jsonEncode(_tasks.map((e) => e.toJson()).toList());
    final milestonesJson = jsonEncode(_milestones.map((e) => e.toJson()).toList());

    await prefs.setString('habits_data', habitsJson);
    await prefs.setString('tasks_data', tasksJson);
    await prefs.setString('milestones_data', milestonesJson);
    await prefs.setInt('streak_freezes', _streakFreezes);
    await prefs.setInt('best_overall_streak', _bestOverallStreak);
  }

  // Recalculates both individual streaks and overall "Perfect Days" streak
  void _recalculateAllStreaks() {
    for (var habit in _habits) {
      habit.recalculateStreak();
    }

    // Calculate Overall Perfect Days streak
    int perfectStreak = 0;
    DateTime checkDate = DateTime.now();

    // If today is a perfect day so far, include it
    if (isPerfectDay(checkDate)) {
      perfectStreak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else {
      // Check from yesterday backwards
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // Walk backwards
    while (true) {
      if (isPerfectDay(checkDate)) {
        perfectStreak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }

      if (perfectStreak > 1000) break; // safety
    }

    _overallPerfectStreak = perfectStreak;
    if (_overallPerfectStreak > _bestOverallStreak) {
      _bestOverallStreak = _overallPerfectStreak;
    }
  }

  /// Determines if a specific date was a "Perfect Day":
  /// All scheduled habits completed or rested, and all tasks due on that date completed.
  bool isPerfectDay(DateTime date) {
    final dateStr = Habit.formatDate(date);
    final scheduledHabits = _habits.where((h) => h.isScheduledFor(date)).toList();

    if (scheduledHabits.isEmpty) {
      return false;
    }

    for (var habit in scheduledHabits) {
      final isDone = habit.completedDates.contains(dateStr);
      final isRest = habit.restDates.contains(dateStr);
      if (!isDone && !isRest) {
        return false;
      }
    }

    return true;
  }

  // --- Habit Actions ---

  Future<void> addHabit({
    required String title,
    String iconName = 'Weights',
    int colorHex = 0xFF58CC02,
    required Set<int> scheduledWeekdays,
  }) async {
    final newHabit = Habit(
      id: const Uuid().v4(),
      title: title,
      iconName: iconName,
      colorHex: colorHex,
      scheduledWeekdays: scheduledWeekdays,
    );
    _habits.add(newHabit);
    _recalculateAllStreaks();
    await _saveData();
    notifyListeners();
  }

  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((h) => h.id == id);
    _recalculateAllStreaks();
    await _saveData();
    notifyListeners();
  }

  /// Toggles habit completion for a given date
  Future<bool> toggleHabitCompletion(String id, DateTime date) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    final dateStr = Habit.formatDate(date);

    bool nowCompleted = false;
    if (habit.completedDates.contains(dateStr)) {
      habit.completedDates.remove(dateStr);
    } else {
      habit.completedDates.add(dateStr);
      // Remove rest if previously marked rest
      habit.restDates.remove(dateStr);
      nowCompleted = true;
    }

    _recalculateAllStreaks();
    await _saveData();
    notifyListeners();
    return nowCompleted;
  }

  /// Marks a habit as Rest for a specific date (does NOT break streak, does NOT consume freeze)
  Future<void> markHabitRest(String id, DateTime date) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    final dateStr = Habit.formatDate(date);

    if (habit.restDates.contains(dateStr)) {
      habit.restDates.remove(dateStr);
    } else {
      habit.restDates.add(dateStr);
      habit.completedDates.remove(dateStr);
    }

    _recalculateAllStreaks();
    await _saveData();
    notifyListeners();
  }

  /// Uses a streak freeze for a habit on a specific date
  Future<bool> useStreakFreeze(String id, DateTime date) async {
    if (_streakFreezes <= 0) return false;

    final habit = _habits.firstWhere((h) => h.id == id);
    final dateStr = Habit.formatDate(date);

    if (!habit.frozenDates.contains(dateStr)) {
      habit.frozenDates.add(dateStr);
      _streakFreezes--;
      _recalculateAllStreaks();
      await _saveData();
      notifyListeners();
      return true;
    }
    return false;
  }

  // --- Task Actions ---

  Future<void> addTask({
    required String title,
    required DateTime dueDate,
  }) async {
    final newTask = DailyTask(
      id: const Uuid().v4(),
      title: title,
      dueDate: dueDate,
    );
    _tasks.add(newTask);
    _recalculateAllStreaks();
    await _saveData();
    notifyListeners();
  }

  Future<void> toggleTask(String id) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == id);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      task.isCompleted = !task.isCompleted;
      task.completedAt = task.isCompleted ? DateTime.now() : null;
      _recalculateAllStreaks();
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    _recalculateAllStreaks();
    await _saveData();
    notifyListeners();
  }

  // --- Milestone and Freeze Actions ---

  Future<void> addStreakFreezes(int count) async {
    _streakFreezes += count;
    await _saveData();
    notifyListeners();
  }

  Future<void> claimMilestone(int targetDays) async {
    final milestone = _milestones.firstWhere((m) => m.targetDays == targetDays);
    if (!milestone.isClaimed) {
      milestone.isClaimed = true;
      _streakFreezes += milestone.rewardFreezes;
      await _saveData();
      notifyListeners();
    }
  }
}
