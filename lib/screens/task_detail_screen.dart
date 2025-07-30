import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/cubit/tasks_cubit.dart';
import 'package:to_do_uygulamsi/models/task.dart';
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
        title: Text('Görev Detayı', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: _saveChange,
          ),
        ],
      ),
      body: Padding(
        padding: Paddings.all16,
        child: TextField(
          controller: _titleController,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
          ),
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Görev Başlığı',
            labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
