import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/cubit/tasks_cubit.dart';
import 'package:to_do_uygulamsi/cubit/tasks_state.dart';
import 'package:to_do_uygulamsi/screens/task_detail_screen.dart';
import 'package:to_do_uygulamsi/theme/app_theme.dart';
import 'package:to_do_uygulamsi/widgets/task_item.dart';
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
            return Center(child: AppText.NoMissionsYetText);
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return TaskItem(
                task: task,
                onToggleDone: () =>
                    context.read<TasksCubit>().toggleTask(task.id),
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
}

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggleDone,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.isCompleted;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDarkMode
        ? (isDone ? AppColors.charlestonGreen : AppColors.onyx)
        : (isDone ? AppColors.white70 : AppColors.white);

    final Color textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: const Duration(milliseconds: 500),
        openColor: backgroundColor,
        closedColor: backgroundColor,
        closedElevation: 2,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        openBuilder: (context, _) => TaskDetailScreen(task: task),
        closedBuilder: (context, openContainer) => ListTile(
          onTap: openContainer,
          leading: Checkbox(value: isDone, onChanged: (_) => onToggleDone()),
          title: Text(
            task.title,
            style: TextStyle(
              color: textColor,
              decoration: isDone ? TextDecoration.lineThrough : null,
              decorationColor: textColor.withOpacity(0.7),
              decorationThickness: isDone ? 2.0 : 1.0,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.primaryColor),
                onPressed: openContainer,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: AppColors.redAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
