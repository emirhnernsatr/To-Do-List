import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_cubit.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_state.dart';
import 'package:to_do_uygulamsi/screens/home/model/task_model.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';
import 'package:to_do_uygulamsi/core/constants/app_strings.dart';
import 'package:to_do_uygulamsi/screens/home/widget/task_detail_widgets.dart';

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

  Future<void> _saveChange() async {
    final newTitle = _titleController.text.trim();
    final newNote = _noteController.text.trim();
    final newDate = _selectedDate ?? DateTime.now();
    final newTime = _selectedTime ?? TimeOfDay.now();

    await context.read<HomeCubit>().newTaskChanges(
      id: widget.task.id,
      newTitle: newTitle,
      newNote: newNote,
      newDate: newDate,
      newTime: newTime,
    );
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocListener<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is HomeTaskUpdated) {
                    Navigator.pop(context);
                  }
                },
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    String? errorText;

                    if (state is HomeError) {
                      errorText = state.message;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        taskTitleTextField(
                          controller: _titleController,
                          isDark: isDark,
                        ),

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
              ),

              AppSpacing.h(16),
              infoCard(isDark: isDark, task: widget.task),

              AppSpacing.h(16),
              statusCard(isDark: isDark, task: widget.task),

              AppSpacing.h(20),

              Row(
                children: [
                  Expanded(
                    child: dateTextfield(
                      isDark: isDark,
                      selectedDate: _selectedDate,
                      onTap: _selectDate,
                    ),
                  ),
                  AppSpacing.h(16),
                  AppSpacing.w(8),
                  Expanded(
                    child: timeTextfield(
                      context: context,
                      isDark: isDark,
                      selectedTime: _selectedTime,
                      onTap: _selectTime,
                    ),
                  ),
                ],
              ),
              AppSpacing.h(40),

              noteTextfield(
                controller: _noteController,
                isDark: isDark,
                maxLine: 10,
              ),

              AppSpacing.h(60),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: saveElevatedButtton(onPressed: _saveChange),
              ),
            ],
          ),
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
}
