---
name: duolingo-habit-tracker
description: Definitive architectural guidelines, layout constraints, streak & freeze mechanics, asset mapping, and phased implementation rules for the Flutter Duolingo-inspired Habit Tracker app.
---

# Duolingo Habit Tracker Skill Guide

This skill governs the development of the Flutter **Duolingo-Inspired Gamified Habit Tracker**.

---

## 1. Absolute Layout & Navigation Directives

1. **NO BOTTOM BAR**:
   - The user interface **must not** contain any `BottomNavigationBar`, persistent footer, or bottom navigation bar.
   - The main viewport has a clean bottom space with a scrollable card area.
2. **TOP NAVIGATION BAR**:
   - **Flame Streak Pill**: Overall "Perfect Days" streak count (`streak.svg` + number in `#FF9600`).
   - **Ice Freezes Pill**: Available streak freezes (`freezed.svg` + count in `#1CB0F6`).
   - **Calendar Button**: Tapping `calendarpageviewbutton.svg` pushes the **Calendar & Progress Hub** page.
3. **HOME SCREEN (HORIZONTAL CARDS)**:
   - Habits for today are displayed as **horizontal cards** with 3D chunky tactile elevation.
   - Each card displays its own individual habit streak count.
   - Card states: Unchecked (`unchecked.svg`), Checked (`checked.svg`), Freezed (`freezed.svg`), and Rest Day (`restfortodaysworkout.svg`).
4. **REST DAY SYSTEM**:
   - Marking a habit as "Rest" preserves the streak, skips today without penalty, and **does not consume a streak freeze**.
5. **WEEKLY CELEBRATION MODAL**:
   - Tapping the checkmark on a habit triggers an animated sheet showing the **7 day SVGs** (`Mondaychecked.svg` ... `Sundaychecked.svg`), incrementing the habit streak with high-dopamine celebratory feedback.
6. **CALENDAR & PROGRESS HUB**:
   - **Top Stat Cards**: Overall perfect days, longest streak, available freezes, total habits.
   - **Dropdown Selector**: Switch between *"⭐ Perfect Days Streak"* and individual habits.
   - **Monthly Calendar**: Blob-connected streaks showing consecutive completed days.
   - **Milestone Path**: Staggered milestone nodes (10, 15, 20, 30+ days) connected by a dashed line. Unlocking or tapping a milestone triggers celebratory video playback (`Animation1.mp4`, `Animation2.mp4`, `Animation3.mp4`) and rewards bonus streak freezes.
7. **START AFRESH**:
   - Do not reuse or keep old legacy pages or inconsistent tabs. Build cleanly according to [blueprint.md](file:///c:/Users/LENOVO231/appppp/myapp1/blueprint.md).

---

## 2. Design System Tokens (From DESIGN.md)

- **Brand Primary**: Owl Green `#58CC02` (3D Shadow: `#58A700`)
- **Streak Primary**: Streak Orange `#FF9600` (3D Shadow: `#CC7A00`)
- **Freeze Accent**: Eel Blue `#1CB0F6` (3D Shadow: `#1899D6`)
- **Background**: Snow `#FFFFFF` / Soft Surface `#F7F7F7`
- **Borders**: Swan `#E5E5E5` (2px solid, never hairlines)
- **Radii**: 16px to 20px on cards & buttons; 9999px on pills
- **Typography**: `DINRoundPro` (bold 700/800 for titles and buttons) and `DuolingoFeather`

---

## 3. Asset Mapping Reference

| Asset | Path | Role |
| :--- | :--- | :--- |
| **Streak Flame** | `assets/images/streak.svg` | Top bar overall streak icon |
| **Freeze Snowflake** | `assets/images/freezed.svg` | Top bar streak freeze counter & frozen day cell |
| **Checkmark** | `assets/images/checked.svg` | Completed habit state |
| **Unchecked Circle** | `assets/images/unchecked.svg` | Incomplete habit state |
| **Rest Action** | `assets/images/restfortodaysworkout.svg` | Rest day toggle & badge |
| **Calendar Nav** | `assets/images/calendarpageviewbutton.svg` | Top bar button to open Calendar page |
| **Day SVGs** | `assets/images/{Day}{checked|unchecked|freezed}.svg` | Week-view celebration modal & calendar |
| **Milestone Videos** | `assets/videos/Animation{1,2,3}.mp4` | Full-screen video celebrations for streak milestones |
| **Trophy & Chest** | `assets/images/Trophy.svg`, `streakchamp.svg`, `10_day_streak.svg`, `goldenchestclosed.svg` | Milestone path nodes & badges |
| **Widget Backdrops** | `assets/widget_backgrounds/wb{1-5}.svg`, `Special Task.svg` | Habit & task card backgrounds |

---

## 4. Tactile 3D Button Pattern (Flutter)

```dart
class SquishyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color shadowColor;
  final double height;
  final double borderRadius;

  const SquishyButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.backgroundColor,
    required this.shadowColor,
    this.height = 54,
    this.borderRadius = 16,
  });

  @override
  State<SquishyButton> createState() => _SquishyButtonState();
}

class _SquishyButtonState extends State<SquishyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        height: widget.height,
        margin: EdgeInsets.only(top: _isPressed ? 4.0 : 0.0),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: widget.shadowColor,
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
```

---

## 5. Development Phases

1. **Phase 1: Pure Domain & Provider State Engine**
   - Clean data models: `Habit`, `DailyTask`, `MilestoneProgress`, `AppStats`.
   - Comprehensive logic for individual habit streaks, perfect days, auto-freezes, and rest days with persistent local storage (`shared_preferences`).
2. **Phase 2: 3D Design System & Components**
   - Reusable `SquishyButton`, `TactileCard`, `SvgIconLoader`, and theme tokens.
3. **Phase 3: Clean Home Screen**
   - Top bar (streak, freezes, calendar button).
   - Horizontal cards carousel with habit status, rest toggle, and streak badge.
   - Tasks for the day with deadline system.
4. **Phase 4: Week-View Celebration Modal**
   - Animated bottom sheet with `Mondaychecked.svg` ... `Sundaychecked.svg`.
   - Dynamic streak increment and Duolingo 3D "Continue" button.
5. **Phase 5: Creation Modals**
   - Habit creation with weekday selection chips (Mon–Sun).
   - Task creation with month and date deadline selection.
6. **Phase 6: Calendar & Progress Hub**
   - Dropdown view switcher (Perfect Days vs. Individual Habits).
   - Monthly calendar with Duolingo blob connectors.
   - Top summary metrics cards.
7. **Phase 7: Milestone Path & Video Celebration**
   - Staggered milestone path nodes.
   - Video player overlay for `Animation1.mp4`, `Animation2.mp4`, `Animation3.mp4` with rewards sheet.
