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

  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
  }

  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveChange() {
    final newTitle = _titleController.text.trim();
    if (newTitle.isNotEmpty && newTitle != widget.task.title) {
      context.read<TasksCubit>().editTask(widget.task.id, newTitle);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: AppText.TaskDetailsText,
        leading: _arrowBackButton(context),
        actions: [_saveButton()],
      ),
      body: Padding(
        padding: Paddings.all16,
        child: _taskTitleTextField(isDark),
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
          color: isDark ? AppColors.white : AppColors.black,
        ),
        border: OutlineInputBorder(),
      ),
    );
  }

  IconButton _saveButton() {
    return IconButton(
      icon: Icon(Icons.save, color: AppColors.white),
      onPressed: _saveChange,
    );
  }

  IconButton _arrowBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: AppColors.white),
      onPressed: () => Navigator.pop(context),
    );
  }
}
