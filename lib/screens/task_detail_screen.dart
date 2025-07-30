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
  late TextEditingController _descriptionController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );
  }

  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _infoCard(isDark),
            sizedBoxH(16),

            _taskTitleTextField(isDark),

            sizedBoxH(16),
            _statusCard(isDark),

            sizedBoxH(16),
            _descriptionCard(isDark),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(bool isDark) {
    final DateTime? time = widget.task.timestamp;
    final String formattedDate = time != null
        ? '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        : 'Tarih Bilgisi Yok';
    return Card(
      color: isDark ? Color(0xFF2A2A2A) : Colors.grey.shade100,
      elevation: 3,
      child: Padding(
        padding: Paddings.all16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Olusturulma Tarihi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
      color: isDark ? Color(0xFF2A2A2A) : Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Padding(
        padding: Paddings.all16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Görev Durumu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              isCompleted ? 'Tamamlandı' : 'Tamamlanmadı',
              style: TextStyle(
                fontSize: 16,
                color: isCompleted
                    ? Colors.green
                    : (isDark ? AppColors.redAccent : AppColors.redAccent),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _descriptionCard(bool isDark) {
    return Card(
      color: isDark ? Color(0xFF2A2A2A) : Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Görev Açıklaması',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              trailing: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 6,
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Görev açıklaması',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF2A2A2A)
                        : Colors.grey[200],
                  ),
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
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
          color: isDark ? AppColors.white : AppColors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: isDark ? Color(0xFF2A2A2A) : Colors.grey[100],
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
