import 'package:intl/intl.dart';

class Habit {
  final String id;
  String title;
  String iconName; // e.g. 'Weights', 'readbook', 'lightning', 'Goals'
  int colorHex; // Hex color for card accent
  Set<int> scheduledWeekdays; // 1 = Monday, 7 = Sunday
  Set<String> completedDates; // 'YYYY-MM-DD'
  Set<String> restDates; // 'YYYY-MM-DD' (preserves streak without freeze)
  Set<String> frozenDates; // 'YYYY-MM-DD' (freeze applied)
  int currentStreak;
  int bestStreak;
  DateTime createdAt;

  Habit({
    required this.id,
    required this.title,
    this.iconName = 'Weights',
    this.colorHex = 0xFF58CC02,
    Set<int>? scheduledWeekdays,
    Set<String>? completedDates,
    Set<String>? restDates,
    Set<String>? frozenDates,
    this.currentStreak = 0,
    this.bestStreak = 0,
    DateTime? createdAt,
  })  : scheduledWeekdays = scheduledWeekdays ?? {1, 2, 3, 4, 5, 6, 7},
        completedDates = completedDates ?? <String>{},
        restDates = restDates ?? <String>{},
        frozenDates = frozenDates ?? <String>{},
        createdAt = createdAt ?? DateTime.now();

  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  bool isScheduledFor(DateTime date) {
    return scheduledWeekdays.contains(date.weekday);
  }

  bool isCompletedOn(DateTime date) {
    return completedDates.contains(formatDate(date));
  }

  bool isRestOn(DateTime date) {
    return restDates.contains(formatDate(date));
  }

  bool isFrozenOn(DateTime date) {
    return frozenDates.contains(formatDate(date));
  }

  /// Calculates the active streak for this habit up to today
  void recalculateStreak() {
    int streak = 0;
    DateTime checkDate = DateTime.now();
    final todayStr = formatDate(checkDate);

    // If today is scheduled and completed, start with 1; if rest day, preserve streak
    if (isScheduledFor(checkDate)) {
      if (completedDates.contains(todayStr)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (restDates.contains(todayStr)) {
        // Rest today: continue checking yesterday
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        // Not done yet today - check from yesterday backwards
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    } else {
      // Not scheduled today: check from yesterday
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // Walk backwards in time
    while (true) {
      final dateStr = formatDate(checkDate);
      if (isScheduledFor(checkDate)) {
        if (completedDates.contains(dateStr)) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else if (restDates.contains(dateStr)) {
          // Rest day preserves streak count without incrementing or breaking
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else if (frozenDates.contains(dateStr)) {
          // Frozen day preserves streak
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          // Missed scheduled day without rest or freeze -> streak ends
          break;
        }
      } else {
        // Unscheduled day -> streak continues smoothly
        checkDate = checkDate.subtract(const Duration(days: 1));
      }

      // Safety bound to avoid infinite loop
      if (checkDate.isBefore(createdAt.subtract(const Duration(days: 365)))) {
        break;
      }
    }

    currentStreak = streak;
    if (currentStreak > bestStreak) {
      bestStreak = currentStreak;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'iconName': iconName,
      'colorHex': colorHex,
      'scheduledWeekdays': scheduledWeekdays.toList(),
      'completedDates': completedDates.toList(),
      'restDates': restDates.toList(),
      'frozenDates': frozenDates.toList(),
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    final habit = Habit(
      id: json['id'] as String,
      title: json['title'] as String,
      iconName: (json['iconName'] as String?) ?? 'Weights',
      colorHex: (json['colorHex'] as int?) ?? 0xFF58CC02,
      scheduledWeekdays: (json['scheduledWeekdays'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toSet() ??
          {1, 2, 3, 4, 5, 6, 7},
      completedDates: (json['completedDates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          {},
      restDates: (json['restDates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          {},
      frozenDates: (json['frozenDates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          {},
      currentStreak: (json['currentStreak'] as int?) ?? 0,
      bestStreak: (json['bestStreak'] as int?) ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
    habit.recalculateStreak();
    return habit;
  }
}
