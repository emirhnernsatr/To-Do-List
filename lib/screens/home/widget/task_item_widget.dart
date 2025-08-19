// ignore_for_file: library_private_types_in_public_api

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/core/constants/app_strings.dart';
import 'package:to_do_uygulamsi/screens/home/model/task_model.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';
import 'package:to_do_uygulamsi/screens/home/view/task_detail_view.dart';

class TaskItemWidget extends StatefulWidget {
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
  _TaskItemWidgetState createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.task.isCompleted;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDarkMode
        ? (isDone ? AppColors.charlestonGreen : AppColors.onyx)
        : (isDone ? AppColors.white24 : AppColors.white);

    final Color textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Padding(
      padding: AppPadding.symmetric(horizontal: 8, vertical: 4),
      child: GestureDetector(
        onTap: _toggleExpand,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onToggleDone,
                    child: Transform.scale(
                      scale: 1.4,
                      child: Checkbox(
                        value: isDone,
                        onChanged: (_) => widget.onToggleDone(),
                        shape: const CircleBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.task.title,
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
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'delete') {
                        widget.onDelete();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: OpenContainer(
                          transitionType: ContainerTransitionType.fadeThrough,
                          transitionDuration: const Duration(milliseconds: 500),
                          openColor: backgroundColor,
                          closedColor: Colors.transparent,
                          closedElevation: 0,
                          closedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          openBuilder: (context, _) =>
                              TaskDetailView(task: widget.task),
                          closedBuilder: (context, openContainer) => const Row(
                            children: [
                              Icon(Icons.edit, color: AppColors.primaryColor),
                              SizedBox(width: 8),
                              Text("Düzenle"),
                            ],
                          ),
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
                ],
              ),

              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _isExpanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.task.time != null)
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 16),
                                  const SizedBox(width: 4),
                                  Text(widget.task.time!.format(context)),
                                ],
                              ),
                            if (widget.task.note != null &&
                                widget.task.note!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  widget.task.note!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    // ignore: deprecated_member_use
                                    color: textColor.withOpacity(0.7),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
