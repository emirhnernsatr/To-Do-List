import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/cubit/tasks_cubit.dart';
import 'package:to_do_uygulamsi/models/task.dart';
import 'package:to_do_uygulamsi/theme/app_theme.dart';
import 'package:to_do_uygulamsi/widgets/task_item.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key, required this.task});
  final Task task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
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
    final newNote = _noteController.text.trim();

    final newDate = _selectedDate ?? DateTime.now();
    final newTime = _selectedTime ?? TimeOfDay.now();

    bool hasChanged = false;

    if (newTitle != widget.task.title) hasChanged = true;
    if (newNote != widget.task.note) hasChanged = true;
    if (newDate != widget.task.date) hasChanged = true;
    if (newTime != widget.task.time) hasChanged = true;

    if (hasChanged) {
      context.read<TasksCubit>().editTask(
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
        padding: Paddings.all16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _taskTitleTextField(isDark),

            sizedBoxH(16),
            _infoCard(isDark),

            sizedBoxH(16),
            _statusCard(isDark),

            sizedBoxH(20),

            Row(
              children: [
                Expanded(child: _dateTextfield(isDark)),
                sizedBoxH(16),
                sizedBoxW(8),
                Expanded(child: _timeTextfield(context, isDark)),
              ],
            ),
            sizedBoxH(40),

            _noteTextfield(isDark),

            sizedBoxH(60),

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
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        filled: true,
        fillColor: isDark ? AppColors.charlestonGreen : AppColors.white,
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
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
        side: const BorderSide(color: AppColors.primaryColor),
      ),
      color: isDark ? AppColors.charlestonGreen : AppColors.white,
      elevation: 3,
      child: Padding(
        padding: Paddings.all16,
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
        side: const BorderSide(color: AppColors.primaryColor),
      ),
      elevation: 3,
      child: Padding(
        padding: Paddings.all16,
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
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: isDark ? AppColors.charlestonGreen : AppColors.white,
      ),
    );
  }

  IconButton _arrowBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.white),
      onPressed: () => Navigator.pop(context),
    );
  }
}
