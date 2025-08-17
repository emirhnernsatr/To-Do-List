import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_cubit.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_state.dart';
import 'package:to_do_uygulamsi/screens/home/model/task_model.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';
import 'package:to_do_uygulamsi/core/constants/app_strings.dart';

class TaskDetailView extends StatefulWidget {
  final TaskModel task;

  const TaskDetailView({super.key, required this.task});

  @override
  State<TaskDetailView> createState() => _TaskDetailView();
}

class _TaskDetailView extends State<TaskDetailView> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _noteController = TextEditingController(text: widget.task.note);

    _selectedDate = widget.task.date;
    _selectedTime = widget.task.time;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveChange() {
    final newTitle = _titleController.text.trim();

    if (newTitle.isEmpty) {
      context.read<HomeCubit>().validateTitle(newTitle);
      return;
    }

    final newNote = _noteController.text.trim();

    final newDate = _selectedDate ?? DateTime.now();
    final newTime = _selectedTime ?? TimeOfDay.now();

    bool hasChanged = false;

    if (newTitle != widget.task.title) hasChanged = true;
    if (newNote != widget.task.note) hasChanged = true;
    if (newDate != widget.task.date) hasChanged = true;
    if (newTime != widget.task.time) hasChanged = true;

    if (hasChanged) {
      context.read<HomeCubit>().editTask(
        id: widget.task.id,
        newTitle: newTitle,
        newNote: newNote,
        newDate: newDate,
        newTime: newTime,
      );
    }
    Navigator.pop(context);
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: AppText.taskDetailsText,
        centerTitle: true,
        leading: _arrowBackButton(context),
      ),
      body: Padding(
        padding: AppPadding.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                String? errorText;

                if (state is HomeError) {
                  errorText = state.message;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _taskTitleTextField(isDark),

                    if (errorText != null)
                      Padding(
                        padding: AppPadding.only(top: 6),
                        child: Text(
                          errorText,
                          style: const TextStyle(
                            color: AppColors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

            // _taskTitleTextField(isDark),
            AppSpacing.h(16),
            _infoCard(isDark),

            AppSpacing.h(16),
            _statusCard(isDark),

            AppSpacing.h(20),

            Row(
              children: [
                Expanded(child: _dateTextfield(isDark)),
                AppSpacing.h(16),
                AppSpacing.w(8),
                Expanded(child: _timeTextfield(context, isDark)),
              ],
            ),
            AppSpacing.h(40),

            _noteTextfield(isDark),

            AppSpacing.h(60),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: _saveElevatedButtton(),
            ),
          ],
        ),
      ),
    );
  }

  IconButton _arrowBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.white),
      onPressed: () => Navigator.pop(context),
    );
  }

  TextField _taskTitleTextField(bool isDark) {
    return TextField(
      controller: _titleController,
      style: TextStyle(
        color: isDark ? AppColors.white : AppColors.black,
        fontSize: 16,
      ),
      autofocus: true,
      decoration: InputDecoration(
        labelText: 'Görev Başlığı',
        labelStyle: TextStyle(
          color: isDark ? AppColors.white : AppColors.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: isDark ? AppColors.charlestonGreen : AppColors.white,
      ),
    );
  }

  Widget _infoCard(bool isDark) {
    final DateTime time = widget.task.timestamp;
    // ignore: unnecessary_null_comparison
    final String formattedDate = time != null
        ? '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        : 'Tarih Bilgisi Yok';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      color: isDark ? AppColors.charlestonGreen : AppColors.white,
      elevation: 3,
      child: Padding(
        padding: AppPadding.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.creationDate,
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusCard(bool isDark) {
    final bool isCompleted = widget.task.isCompleted;
    return Card(
      color: isDark ? AppColors.charlestonGreen : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      elevation: 3,
      child: Padding(
        padding: AppPadding.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Görev Durumu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              isCompleted ? 'Tamamlandı' : 'Tamamlanmadı',
              style: TextStyle(
                fontSize: 16,
                color: isCompleted
                    ? AppColors.green
                    : (isDark ? AppColors.redAccent : AppColors.redAccent),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _timeTextfield(BuildContext context, bool isDark) {
    return TextFormField(
      readOnly: true,
      onTap: _selectTime,
      controller: TextEditingController(
        text: _selectedTime != null ? _selectedTime!.format(context) : '',
      ),
      decoration: InputDecoration(
        labelText: 'Saat',
        labelStyle: TextStyle(
          color: isDark ? AppColors.white : AppColors.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: const Icon(
          Icons.access_time,
          color: AppColors.primaryColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: isDark ? AppColors.charlestonGreen : AppColors.white,
      ),
    );
  }

  TextField _dateTextfield(bool isDark) {
    return TextField(
      readOnly: true,
      onTap: _selectDate,
      controller: TextEditingController(
        text: _selectedDate != null
            ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
            : '',
      ),
      decoration: InputDecoration(
        labelText: 'Tarih',
        labelStyle: TextStyle(
          color: isDark ? AppColors.white : AppColors.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: const Icon(
          Icons.calendar_today,
          color: AppColors.primaryColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: isDark ? AppColors.charlestonGreen : AppColors.white,
      ),
    );
  }

  TextFormField _noteTextfield(bool isDark) {
    return TextFormField(
      controller: _noteController,
      maxLines: 10,
      decoration: InputDecoration(
        labelText: 'Notlar',
        labelStyle: TextStyle(
          color: isDark ? AppColors.white : AppColors.primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        alignLabelWithHint: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: isDark ? AppColors.charlestonGreen : AppColors.white,
      ),
    );
  }

  ElevatedButton _saveElevatedButtton() {
    return ElevatedButton(
      onPressed: _saveChange,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: AppText.saveText,
    );
  }
}
