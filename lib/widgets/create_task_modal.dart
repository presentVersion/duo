import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../habit_provider.dart';
import '../theme/app_colors.dart';
import 'svg_asset.dart';
import 'squishy_button.dart';

class CreateTaskModal extends StatefulWidget {
  const CreateTaskModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateTaskModal(),
    );
  }

  @override
  State<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends State<CreateTaskModal> {
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final provider = Provider.of<HabitProvider>(context, listen: false);
    provider.addTask(title: title, dueDate: _selectedDate);
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.owlGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.eelBlack,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
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
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
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

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Daily Task',
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

            // Title
            const Text(
              'TASK TITLE',
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
                hintText: 'e.g. Complete math assignment, Pay bills',
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

            // Deadline with month/day picker
            const Text(
              'DEADLINE (MONTH & DAY)',
              style: TextStyle(
                fontFamily: 'DINRoundPro',
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.wolf,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.swan, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded, color: AppColors.streakOrange, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('MMMM d, yyyy').format(_selectedDate),
                      style: const TextStyle(
                        fontFamily: 'DINRoundPro',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.eelBlack,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Change',
                      style: TextStyle(
                        fontFamily: 'DINRoundPro',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.eelBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: SquishyButton(
                backgroundColor: AppColors.streakOrange,
                shadowColor: AppColors.streakOrangeDeep,
                onPressed: _saveTask,
                height: 54,
                child: const Text(
                  'CREATE TASK',
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
    );
  }
}
