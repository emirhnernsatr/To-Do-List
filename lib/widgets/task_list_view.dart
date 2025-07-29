import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/cubit/tasks_cubit.dart';
import 'package:to_do_uygulamsi/cubit/tasks_state.dart';
import 'package:to_do_uygulamsi/theme/app_theme.dart';
import '../models/task.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is TasksError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is TasksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TasksLoaded) {
          final tasks = state.filteredTasks;

          if (tasks.isEmpty) {
            return const Center(child: Text('Henüz görev yok'));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return TaskItem(
                task: task,
                onToggleDone: () =>
                    context.read<TasksCubit>().toggleTask(task.id),
                onEdit: () => _editTask(context, task),
                onDelete: () => context.read<TasksCubit>().deleteTask(task.id),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void _editTask(BuildContext context, Task task) {
    final editController = TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Görevi Düzenle'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Yeni Başlık'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = editController.text.trim();
              if (newTitle.isNotEmpty) {
                context.read<TasksCubit>().editTask(task.id, newTitle);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggleDone,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.isCompleted;

    return Card(
      color: isDone ? AppColors.white70 : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: isDone,
          onChanged: (_) => onToggleDone(),
          activeColor: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: isDone ? Colors.black : null,
            decoration: isDone ? TextDecoration.lineThrough : null,
            decorationColor: Colors.black,
            decorationThickness: isDone ? 2.0 : 1.0,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.primaryColor),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: AppColors.grey),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
