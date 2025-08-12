import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/screens/home/model/task_model.dart';
import 'package:to_do_uygulamsi/screens/home/view/task_detail_view.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;

  const TaskItemWidget({
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
        openBuilder: (context, _) => TaskDetailView(task: task),
        closedBuilder: (context, openContainer) => ListTile(
          onTap: openContainer,
          leading: GestureDetector(
            onTap: onToggleDone,
            child: Checkbox(value: isDone, onChanged: (_) => onToggleDone()),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              color: textColor,
              decoration: isDone ? TextDecoration.lineThrough : null,
              // ignore: deprecated_member_use
              decorationColor: textColor.withOpacity(0.7),
              decorationThickness: isDone ? 2.0 : 1.0,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                onPressed: openContainer,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: AppColors.redAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
