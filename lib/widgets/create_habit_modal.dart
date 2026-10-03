import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../habit_provider.dart';
import '../theme/app_colors.dart';
import 'svg_asset.dart';
import 'squishy_button.dart';

class CreateHabitModal extends StatefulWidget {
  const CreateHabitModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateHabitModal(),
    );
  }

  @override
  State<CreateHabitModal> createState() => _CreateHabitModalState();
}

class _CreateHabitModalState extends State<CreateHabitModal> {
  final _titleController = TextEditingController();
  String _selectedIcon = 'Weights';
  int _selectedColor = 0xFF58CC02;
  final Set<int> _selectedWeekdays = {1, 2, 3, 4, 5, 6, 7}; // Default: Everyday

  final List<String> _icons = [
    'Weights',
    'readbook',
    'lightning',
    'Goals',
    'Trophy',
  ];

  final List<int> _colors = [
    0xFF58CC02, // Owl Green
    0xFFFF9600, // Streak Orange
    0xFF1CB0F6, // Eel Blue
    0xFFCE82FF, // Gem Pink
    0xFFFFC800, // Bee Yellow
  ];

  final List<Map<String, dynamic>> _weekdays = [
    {'day': 1, 'label': 'M'},
    {'day': 2, 'label': 'T'},
    {'day': 3, 'label': 'W'},
    {'day': 4, 'label': 'T'},
    {'day': 5, 'label': 'F'},
    {'day': 6, 'label': 'S'},
    {'day': 7, 'label': 'S'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    if (_selectedWeekdays.isEmpty) return;

    final provider = Provider.of<HabitProvider>(context, listen: false);
    provider.addHabit(
      title: title,
      iconName: _selectedIcon,
      colorHex: _selectedColor,
      scheduledWeekdays: _selectedWeekdays,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.snow,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border(
            top: BorderSide(color: AppColors.swan, width: 2),
            left: BorderSide(color: AppColors.swan, width: 2),
            right: BorderSide(color: AppColors.swan, width: 2),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.swan,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Modal Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create New Habit',
                    style: TextStyle(
                      fontFamily: 'DINRoundPro',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.eelBlack,
                    ),
                  ),
                  IconButton(
                    icon: const SvgAsset(assetName: 'close.svg', width: 20, height: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title Field
              const Text(
                'HABIT NAME',
                style: TextStyle(
                  fontFamily: 'DINRoundPro',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.wolf,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'e.g. Morning Yoga, Read 10 Pages',
                  hintStyle: const TextStyle(
                    fontFamily: 'DINRoundPro',
                    color: AppColors.hare,
                    fontSize: 15,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.swan, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.swan, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.eelBlue, width: 2),
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'DINRoundPro',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              // Weekday Selection
              const Text(
                'REPEAT DAYS',
                style: TextStyle(
                  fontFamily: 'DINRoundPro',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.wolf,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _weekdays.map((item) {
                  final int day = item['day'];
                  final String label = item['label'];
                  final isSelected = _selectedWeekdays.contains(day);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          if (_selectedWeekdays.length > 1) {
                            _selectedWeekdays.remove(day);
                          }
                        } else {
                          _selectedWeekdays.add(day);
                        }
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.owlGreen : AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.owlGreenDeep : AppColors.swan,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? const [
                                BoxShadow(
                                  color: AppColors.owlGreenDeep,
                                  offset: Offset(0, 2),
                                  blurRadius: 0,
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'DINRoundPro',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : AppColors.wolf,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Icon Selection
              const Text(
                'CHOOSE ICON',
                style: TextStyle(
                  fontFamily: 'DINRoundPro',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.wolf,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _icons.map((iconName) {
                  final isSelected = _selectedIcon == iconName;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = iconName),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(_selectedColor).withOpacity(0.15)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? Color(_selectedColor)
                              : AppColors.swan,
                          width: isSelected ? 2.5 : 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: SvgAsset(
                        assetName: '$iconName.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Color Selection
              const Text(
                'ACCENT COLOR',
                style: TextStyle(
                  fontFamily: 'DINRoundPro',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.wolf,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _colors.map((hex) {
                  final isSelected = _selectedColor == hex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = hex),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Color(hex),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.eelBlack : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 22)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: SquishyButton(
                  backgroundColor: AppColors.owlGreen,
                  shadowColor: AppColors.owlGreenDeep,
                  onPressed: _saveHabit,
                  height: 54,
                  child: const Text(
                    'CREATE HABIT',
                    style: TextStyle(
                      fontFamily: 'DINRoundPro',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
