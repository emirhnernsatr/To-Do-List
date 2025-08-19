import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/core/constants/app_strings.dart';
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
        : (isDone ? AppColors.white24 : AppColors.white);

    final Color textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Padding(
      padding: AppPadding.symmetric(horizontal: 8, vertical: 4),
      child: Card(
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
              child: Transform.scale(
                scale: 1.4,
                child: Checkbox(
                  value: isDone,
                  onChanged: (_) => onToggleDone(),
                  shape: const CircleBorder(),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    // ignore: deprecated_member_use
                    decorationColor: textColor.withOpacity(0.7),
                    decorationThickness: isDone ? 2.0 : 1.0,
                  ),
                ),

                if (task.time != null)
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(task.time!.format(context)),
                    ],
                  ),

                if (task.note != null && task.note!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      task.note!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        // ignore: deprecated_member_use
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ),
              ],
            ),

            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  openContainer();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: AppColors.primaryColor),
                      SizedBox(width: 8),
                      Text("Düzenle"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text("Sil"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
