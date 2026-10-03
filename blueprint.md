# Master Blueprint: Duolingo-Inspired Gamified Habit Tracker

> **App Architecture, Layout & Design Specification**  
> **Platform**: Flutter (Android, iOS, Web)  
> **Visual Identity**: Duolingo Design System (Owl Green `#58CC02`, 3D Chunky Shadows, DIN Round Pro / Feather Bold)  
> **Source of Truth for All Agents & Implementations**

---

## 1. Executive Summary & Core Philosophy

This application is a **high-dopamine, gamified habit tracker** inspired directly by Duolingo's streak psychology and tactile design language. Rather than a language learning curriculum path, the application centers on **daily life routines, fitness, productivity habits, and targeted tasks**.

### The Dopamine Engine:
- **Instant Tactile Gratification**: 3D chunky buttons that visually press down 4px with crisp sound and haptic feedback.
- **Streak Protection & Flexibility**:
  - **Individual Habit Streaks**: Each habit maintains its own streak counter.
  - **Overall "Perfect Day" Streak**: The master top bar streak represents consecutive days where **100% of scheduled habits and tasks** for that day were fulfilled.
  - **Streak Freezes**: Prevent streak death on unexpected busy days.
  - **Rest Day System**: Deliberate rest days (e.g., workout recovery) **do not break streaks** and **do not consume streak freezes**.
- **Celebratory Milestones**: Reaching milestone thresholds (10, 15, 20, 30, 50+ days) triggers celebratory full-screen video animations (`Animation1.mp4`, `Animation2.mp4`, `Animation3.mp4`), unlocking trophies and awarding bonus Streak Freezes.
- **Micro-Celebration on Check**: Checking off a habit launches a dynamic celebratory sheet/dialog showing the weekly streak progression (`Mondaychecked.svg` ... `Sundaychecked.svg`) and animated streak increments.

---

## 2. Navigation Architecture & Screen Layout

### 2.1 Strictly No Bottom Navigation Bar
> **CRITICAL RULE**: The bottom space is kept entirely clean. There is **NO BottomNavigationBar** or bottom tab bar in this application. Navigation flows directly from the Home Page to the Calendar/Progress Hub and Modals.

```
┌────────────────────────────────────────────────────────────┐
│                       HOME SCREEN                          │
├────────────────────────────────────────────────────────────┤
│ [Top Bar]:  🔥 Streak (Perfect Days)  🧊 Freezes  📅 [Cal] │
├────────────────────────────────────────────────────────────┤
│                                                            │
│ ┌────────────────────────────────────────────────────────┐ │
│ │  Today's Habits (Horizontal Swipeable / Staggered Cards)│ │
│ │  [Habit Card: Icon | Title | Streak | Check/Rest/Freeze]│ │
│ └────────────────────────────────────────────────────────┘ │
│                                                            │
│ ┌────────────────────────────────────────────────────────┐ │
│ │  Tasks For The Day & Deadlines (Month Selection)       │ │
│ └────────────────────────────────────────────────────────┘ │
│                                                            │
│ [ + Add Habit / Task Squishy Button (or FAB) ]            │
└────────────────────────────────────────────────────────────┘
                              │
                    Tap Calendar Icon [📅]
                              ▼
┌────────────────────────────────────────────────────────────┐
│                 CALENDAR & PROGRESS HUB                    │
├────────────────────────────────────────────────────────────┤
│ [Back Button]               Stats & Streaks                │
├────────────────────────────────────────────────────────────┤
│ ┌────────────────────────────────────────────────────────┐ │
│ │ Top Stat Cards: Perfect Days | Habit Streaks | Freezes │ │
│ └────────────────────────────────────────────────────────┘ │
│                                                            │
│ [ Dropdown: "Perfect Days Streak" ▾ | Specific Habit ▾ ]   │
│                                                            │
│ ┌────────────────────────────────────────────────────────┐ │
│ │  Duolingo Monthly Calendar View (Blob-connected days)  │ │
│ └────────────────────────────────────────────────────────┘ │
│                                                            │
│ ┌────────────────────────────────────────────────────────┐ │
│ │  Milestone Path (10, 15, 20, 30-day staggered nodes)   │ │
│ │  Rewards video celebration + Streak Freeze rewards    │ │
│ └────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────┘
```

---

## 3. Screen-by-Screen Detailed Specifications

### 3.1 Top Navigation Bar (Persistent on Home)
- **Container**: White surface with bottom border (`#E5E5E5`, 2px solid), elevation zero.
- **Left Element — Overall Perfect Day Streak**:
  - Pill container (`#FFF7ED` or `#F7F7F7`, border `#E5E5E5` 2px, radius 16px, padding `6px 14px`).
  - Fire icon: `assets/images/streak.svg` (animated pulse on active streak).
  - Text: Overall perfect streak count (e.g. `🔥 14`) in `DINRoundPro-Bold` / `DuolingoFeather`, color `#FF9600`.
- **Center Element — Streak Freezes Count**:
  - Pill container (`#F0F9FF`, border `#E5E5E5` 2px, radius 16px, padding `6px 14px`).
  - Freeze icon: `assets/images/freezed.svg` (or snowflake icon).
  - Text: Available freeze count (e.g. `🧊 3`) in `DINRoundPro-Bold`, color `#1CB0F6`.
- **Right Element — Calendar Action Button**:
  - Squishy circular/rounded 3D button using `assets/images/calendarpageviewbutton.svg` or 3D bordered icon.
  - Tapping opens the **Calendar & Progress Hub Screen** with smooth slide transition.

---

### 3.2 Home Page Body (Dashboard)

#### A. Greeting & Date Indicator
- Big bold typography: `DINRoundPro-Bold` 28px, color `#3C3C3C`.
- Shows current day & month with motivational Duolingo subheader (e.g., *"Make today count!"* or *"3 habits left today"*).

#### B. Today's Habit Cards (Horizontal Cards)
- **Layout**: Horizontal carousel or stacked card row with smooth horizontal snap / physics.
- **Card Styling (Duolingo 3D Tactile Card)**:
  - Background: `#FFFFFF`.
  - Border: 2px solid `#E5E5E5`.
  - Bottom Shadow: 4px solid `#E5E5E5` (or tinted darker variant when active/completed).
  - Border Radius: 20px.
  - Padding: 16px 20px.
  - Optional thematic background: SVGs from `assets/widget_backgrounds/` (`wb1.svg` to `wb5.svg`).
- **Card Content**:
  - **Habit Icon**: Circular pill with skill color (e.g., `Weights.svg`, `readbook.svg`, or user-selected icon).
  - **Habit Name**: 18px `DINRoundPro-Bold`, color `#3C3C3C`.
  - **Individual Streak Badge**: Small orange pill showing `🔥 8 days`.
  - **Schedule Indicator**: Badges showing scheduled days (e.g. `M • W • F`).
  - **State Actions & Button Indicators**:
    1. **Unchecked State**: Shows hollow/grey circle or `assets/images/unchecked.svg`.
    2. **Checked State**: Shows vibrant green checkmark `assets/images/checked.svg` with glowing border `#58CC02`.
    3. **Rest Day State**: Pill button with `assets/images/restfortodaysworkout.svg` labeled *"Rest Day"*.
       - Tapping marks habit as **Rest**: Preserves streak, bypasses today's requirement, doesn't consume streak freeze.
    4. **Freezed State**: If missed on a prior scheduled day, displays ice blue frost indicator `assets/images/freezed.svg`.

#### C. Micro-Celebration on Habit Completion (Week-View Streak Modal)
When the user taps the checkmark on a habit card:
1. **Button Animation**: The checkmark presses down 4px with satisfying tactile bounce.
2. **Weekly Streak Drawer / Popup**:
   - Pops up an animated modal showing the **7 days of the week** using custom SVGs:
     - `Mondaychecked.svg` / `Mondayunchecked.svg` / `Mondayfreezed.svg`
     - `Tuesdaychecked.svg` / `Tuesdayunchecked.svg` / `Tuesdayfreezed.svg`
     - `Wednesdaychecked.svg` ... `Sundaychecked.svg`
   - Shows habit's streak counter incrementing (e.g. `7` ➔ `8`).
   - Dopamine motivational text: *"Streak extended! Keep the fire burning!"*
   - Green 3D "Continue" button: `Continuebuttonstatebeforepressed.svg` ➔ `Continuebuttonstateafterpressed.svg`.

#### D. Today's Tasks Section & Deadline System
- **Distinction from Habits**: Tasks are one-off or deadline-driven objectives for the day/month (e.g., *"Submit tax report"*, *"Buy anniversary gift"*).
- **Deadline Feature**:
  - Month selection & specific day deadline picker.
  - Urgency indicators (amber for upcoming, red `#FF4B4B` for due today).
  - Special task background styling: `assets/widget_backgrounds/Special Task.svg`.
  - Completed checkoff: Strikes through and counts toward today's Perfect Day score.

#### E. Creation Modals (Habits & Tasks)
- Squishy floating action or header button (`assets/images/add.svg` or `addwidget.svg`).
- **Habit Creation Pop-Up**:
  - Title input with 2px borders, 12px radius, focus border `#1CB0F6`.
  - Icon selection grid (`Weights.svg`, `readbook.svg`, `lightning.svg`, `Goals.svg`, etc.).
  - Color palette selection (Owl Green, Streak Orange, Eel Blue, Gem Pink, Bee Yellow).
  - **Weekday Selector**: 7 circular toggle buttons (M, T, W, T, F, S, S) allowing custom repeat schedules (e.g., Monday + Wednesday + Friday).
  - Target frequency / reminder time.
  - Green 3D "Create Habit" button.
- **Task Creation Pop-Up**:
  - Task name.
  - Month selector & calendar date picker for deadline.
  - Reminder notification toggle.

---

### 3.3 Calendar & Progress Hub Screen

Accessed via the top bar Calendar Icon (`assets/images/calendarpageviewbutton.svg`).

#### A. Top Stats Summary Cards
Horizontal scrollable row or 3-column grid displaying key metrics:
1. **Total Perfect Days**: Gold trophy / `Trophy.svg`, count of days where 100% completed.
2. **Longest Streak**: Fire icon `streakchamp.svg` / `10_day_streak.svg`.
3. **Streak Freezes Available**: Ice icon `freezed.svg` with "+ Add / Claim" button.
4. **Active Habits Total**: Count of monitored habits.

#### B. The View Selector Dropdown
- A rounded Duolingo pill dropdown / segmented pill:
  - **Option 1**: *"⭐ Perfect Days Streak"* (Default view showing days when all daily goals were achieved).
  - **Option 2...N**: Individual habits (e.g., *"🏋️ Gym Workout"*, *"📚 Reading"*).
- Changing the dropdown immediately updates the calendar highlights and statistics!

#### C. The Duolingo Monthly Calendar View
- Integrated with `table_calendar` customized to Duolingo styling:
  - **Day Cells**:
    - **Completed Day**: Glowing `#58CC02` green or gold pill with day check icon.
    - **Streak Continuation Bridge ("Blob" connection)**: Consecutive completed days are connected by a continuous thick orange/green bridge, exactly like Duolingo's calendar.
    - **Rest Day**: Soft purple or green circle with `restfortodaysworkout.svg` mini badge.
    - **Freezed Day**: Ice blue frosted circle (`freezed.svg`).
    - **Missed Day (Unprotected)**: Hollow dashed border or subtle grey dot.
  - **Monthly Milestone Summary**: Badge at month end: `assets/images/perfect_month.svg` or `perfect_week.svg`.

#### D. The Milestone Path & Rewards
Below the calendar, the user scrolls into the **Milestone Path**:
- **Staggered Node Layout**: Nodes alternate Left, Center, Right along an 8px dashed path (CustomPainter).
- **Milestone Nodes**:
  - **10-Day Streak**: `10_day_streak.svg`
  - **15-Day Streak**: `Icon=Shiny Gold Chest, Size=Small.svg`
  - **20-Day Streak**: `goldenchestclosed.svg`
  - **30-Day Streak**: `streakchamp.svg`
  - **50-Day & 100-Day**: `Trophy.svg`
- **Milestone Unlock Celebration**:
  - When reaching a milestone, the node glows with particle animations.
  - Tapping an unlocked milestone opens the **Full-Screen Video Celebration**:
    - Plays `assets/videos/Animation1.mp4`, `Animation2.mp4`, or `Animation3.mp4` using `video_player`.
    - Rewarding bottom-sheet overlay:
      - *"10-Day Streak Mastered!"*
      - Award: **+1 Streak Freeze** 🧊 & **Shiny Chest Trophy** 🏆.
      - 3D Squishy "Claim Reward" button (`Continuebuttonstatebeforepressed.svg`).

---

## 4. Visual Design System & Tokens

Adheres strictly to [DESIGN.md](file:///c:/Users/LENOVO231/appppp/myapp1/DESIGN.md) and Duolingo Brand Specifications.

### 4.1 Color Palette

| Token Name | Hex Code | Usage |
| :--- | :--- | :--- |
| **Owl Green** | `#58CC02` | Primary brand color, main CTA, completed checkmarks |
| **Owl Green Deep** | `#58A700` | 4px bottom shadow for green buttons |
| **Owl Green Light** | `#89E219` | Hover states, soft fills |
| **Owl Green Pale** | `#DBF8C5` | Success banners, light surfaces |
| **Streak Orange** | `#FF9600` | Flame streak counter, streak milestones |
| **Streak Orange Deep** | `#CC7A00` | 4px bottom shadow for orange elements |
| **Eel Blue** | `#1CB0F6` | Streak freeze accents, info pills, calendar links |
| **Eel Blue Deep** | `#1899D6` | 4px bottom shadow for blue buttons |
| **Gem Pink** | `#CE82FF` | Special milestones, achievements |
| **Cardinal Red** | `#FF4B4B` | Urgent task deadlines, delete actions |
| **Cardinal Red Deep** | `#CC3B3B` | 4px bottom shadow for red buttons |
| **Snow (Background)** | `#FFFFFF` | Primary card and page background |
| **Swan (Border)** | `#E5E5E5` | 2px solid border on cards, inputs, pills |
| **Hare (Divider/Muted)** | `#AFAFAF` | Disabled icons, unselected day rings |
| **Eel Black (Text)** | `#3C3C3C` | Primary bold headers and titles |
| **Wolf (Secondary Text)** | `#777777` | Captions, dates, subtitled text |

### 4.2 Typography
Declared in `pubspec.yaml`:
1. **`DINRoundPro`**:
   - `dinroundpro_bold.otf` (Weight 700 / 800) ➔ Primary headings, buttons, streak counts.
   - `dinroundpro_medi.otf` (Weight 500) ➔ Card subtitles, metadata.
   - `dinroundpro.otf` (Weight 400) ➔ Body text.
2. **`DuolingoFeather`**:
   - `Duolingo Feather Bold.ttf` / `DuolingoFeather.ttf` ➔ Special display numbers and branding.

### 4.3 3D Tactile Button Physics
Every interactive button has:
- `Border.all(color: Colors.transparent)` or `2px solid #E5E5E5`.
- `BoxDecoration` with `boxShadow`:
  ```dart
  BoxShadow(
    color: shadowColor, // e.g. Color(0xFF58A700)
    offset: const Offset(0, 4),
    blurRadius: 0,
  )
  ```
- **Pressed Animation**:
  - `transform: Matrix4.translationValues(0, isPressed ? 4 : 0, 0)`
  - Shadow offset reduces to `0` when pressed, giving the genuine mechanical keyboard / Duolingo press effect.

---

## 5. Asset Catalog & Mapping

### SVGs (`assets/images/`)
- **Daily Day States**:
  - `Mondaychecked.svg`, `Mondayunchecked.svg`, `Mondayfreezed.svg`
  - `Tuesdaychecked.svg`, `Tuesdayunchecked.svg`, `Tuesdayfreezed.svg`
  - `Wednesdaychecked.svg`, `Wednesdayunchecked.svg`, `Wednesdayfreezed.svg`
  - `Thursdaychecked.svg`, `Thursdayunchecked.svg`, `Thursdayfreezed.svg`
  - `Fridaychecked.svg`, `Fridayunchecked.svg`, `Fridayfreezed.svg`
  - `Saturdaychecked.svg`, `Saturdayunchecked.svg`, `Saturdayfreezed.svg`
  - `Sundaychecked.svg`, `Sundayunchecked.svg`, `Sundayfreezed.svg`
- **Core Action & Status SVGs**:
  - `streak.svg` (Top bar streak flame)
  - `freezed.svg` (Streak freeze snowflake)
  - `checked.svg` (Habit completed checkmark)
  - `unchecked.svg` (Incomplete circle)
  - `restfortodaysworkout.svg` (Rest day badge & action)
  - `calendarpageviewbutton.svg` (Top bar calendar launcher)
  - `add.svg`, `addwidget.svg` (Create habit/task)
  - `close.svg`, `back.svg`, `delete.svg` (Dialogs & navigation)
  - `Continuebuttonstatebeforepressed.svg`, `Continuebuttonstateafterpressed.svg`
- **Milestones & Rewards**:
  - `10_day_streak.svg`, `streakchamp.svg`, `Trophy.svg`
  - `goldenchestclosed.svg`, `Icon=Shiny Gold Chest, Size=Small.svg`
  - `perfect_week.svg`, `perfect_month.svg`, `Goals.svg`, `lightning.svg`
- **Habit Categories**:
  - `Weights.svg`, `Property 1=Weights, Available=True.svg`, `readbook.svg`

### Widget Backgrounds (`assets/widget_backgrounds/`)
- `wb1.svg`, `wb2.svg`, `wb3.svg`, `wb4.svg`, `wb5.svg`
- `Special Task.svg`
- `Completed=True, Placement=Solo (1).svg`, `Completed=False, Placement=Solo.svg`

### Video Animations (`assets/videos/`)
- `Animation1.mp4`: 10-day milestone unlock celebration.
- `Animation2.mp4`: 20-day / 30-day streak chest opening.
- `Animation3.mp4`: Perfect month / grand milestone celebration.

---

## 6. Data Architecture & Logic Engine

### 6.1 Habit Model (`lib/models/habit.dart`)
```dart
class Habit {
  final String id;
  String title;
  String iconName; // e.g. 'Weights', 'readbook', 'lightning'
  int colorHex;    // Primary card highlight color
  Set<int> scheduledWeekdays; // 1 = Monday, 7 = Sunday
  Set<String> completedDates; // 'YYYY-MM-DD'
  Set<String> restDates;      // 'YYYY-MM-DD' (preserves streak without freeze)
  Set<String> frozenDates;    // 'YYYY-MM-DD' (consumed streak freeze)
  int currentStreak;
  int bestStreak;
  DateTime createdAt;
}
```

### 6.2 Task Model (`lib/models/task.dart`)
```dart
class DailyTask {
  final String id;
  String title;
  DateTime dueDate; // Selected month & day
  bool isCompleted;
  DateTime? completedAt;
}
```

### 6.3 Streak Calculation Engine
1. **Today's Status for a Habit**:
   - If not scheduled for today (`!scheduledWeekdays.contains(today.weekday)`): **Inactive/Off Day** (Streak is neutral).
   - If scheduled and `completedDates.contains(todayStr)`: **Completed** (+1 to streak).
   - If marked `restDates.contains(todayStr)`: **Rest Day** (Streak remains intact, not incremented, no freeze consumed).
   - If past day was missed:
     - Check if user has available streak freezes (`freezeCount > 0`).
     - Auto-apply freeze: deduct freeze, add to `frozenDates`, streak is protected.
     - Else: Streak resets to 0.
2. **Overall "Perfect Day" Streak**:
   - A date `D` is a **Perfect Day** IF:
     - Every habit scheduled on `D` is either in `completedDates` OR `restDates`.
     - AND all tasks due on or before `D` scheduled for today are `isCompleted == true`.
   - The master top bar streak represents consecutive **Perfect Days**.

---

## 7. Phased Implementation Plan

```
┌────────────────────────────────────────────────────────┐
│               PHASED EXECUTION ROADMAP                 │
├─────────┬──────────────────────────────────────────────┤
│ Phase 1 │ Core State Engine, Models, & SharedPreferences│
├─────────┼──────────────────────────────────────────────┤
│ Phase 2 │ Duolingo 3D Design Tokens & Tactile Widgets  │
├─────────┼──────────────────────────────────────────────┤
│ Phase 3 │ Home Screen & Horizontal Cards (Fresh UI)    │
├─────────┼──────────────────────────────────────────────┤
│ Phase 4 │ Habit Check Celebration & Weekly SVGs Modal  │
├─────────┼──────────────────────────────────────────────┤
│ Phase 5 │ Habit & Task Creation Modals (Weekday/Month) │
├─────────┼──────────────────────────────────────────────┤
│ Phase 6 │ Calendar & Progress Hub (Dropdown & Blobs)   │
├─────────┼──────────────────────────────────────────────┤
│ Phase 7 │ Milestone Path, Video Celebration & Polish   │
└─────────┴──────────────────────────────────────────────┘
```

### Phase 1: Core State Engine & Clean Architecture
- Wipe legacy messy views.
- Define pure data models: `Habit`, `DailyTask`, `MilestoneProgress`, `AppStats`.
- Create `HabitStateProvider` managing state, streak math, auto-freezes, rest days, and persistent storage via `SharedPreferences`.

### Phase 2: Design Tokens & Reusable 3D Tactile Components
- Implement `DuolingoTheme` (`AppColors`, `AppTypography`, `AppBorders`).
- Implement `SquishyButton`: 3D button widget with 4px drop translation and custom sound/haptics.
- Implement `TactileCard`: 3D container with 20px radius and solid borders.
- Implement `SvgAssetIcon`: Helper to reliably load and tint project SVGs.

### Phase 3: Fresh Home Screen (No Bottom Bar)
- Build top navigation bar with:
  - Perfect Day flame pill (`streak.svg`).
  - Ice freeze counter pill (`freezed.svg`).
  - Calendar launcher button (`calendarpageviewbutton.svg`).
- Build horizontal scrollable habit cards for today's scheduled habits.
- Render habit states: Unchecked, Checked, Rest Day, Freezed.

### Phase 4: Weekly Streak Celebration Modal
- Intercept checkmark tap.
- Show animated bottom sheet with the 7 day SVGs (`Mondaychecked.svg` to `Sundaychecked.svg`).
- Animate streak increase with audio feedback.
- Provide Duolingo 3D "Continue" CTA button.

### Phase 5: Creation Modals (Habits & Tasks)
- **Habit Modal**: Weekday selection chips (M, T, W, T, F, S, S), icon grid, title.
- **Task Modal**: Task title, month and date deadline picker, urgent toggle.

### Phase 6: Calendar & Progress Hub
- Top summary stats cards (Longest streak, perfect days count, freeze count).
- View dropdown: Toggle between Perfect Days streak and individual habits.
- Monthly calendar grid with Duolingo blob connectors between consecutive days.

### Phase 7: Milestone Path & Video Celebration
- Render staggered milestone nodes along curved dashed path.
- Hook milestone claim triggers to `Animation1.mp4`, `Animation2.mp4`, `Animation3.mp4` with `video_player`.
- Award bonus streak freezes and update badges.
