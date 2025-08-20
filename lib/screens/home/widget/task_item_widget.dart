// ignore_for_file: library_private_types_in_public_api

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                          closedBuilder: (context, openContainer) {
                            return InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                openContainer();
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(width: 8),
                                  Text("Düzenle"),
                                ],
                              ),
                            );
                          },
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
                            if (widget.task.date != null)
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16),
                                  AppSpacing.w(6),
                                  Text(
                                    DateFormat(
                                      'dd.MM.yyyy',
                                    ).format(widget.task.date!),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            AppSpacing.h(3),
                            if (widget.task.time != null)
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 16),
                                  AppSpacing.w(6),

                                  Text(
                                    widget.task.time!.format(context),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            AppSpacing.h(3),
                            if (widget.task.note != null &&
                                widget.task.note!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.sticky_note_2, size: 16),
                                    AppSpacing.w(6),
                                    Expanded(
                                      child: SizedBox(
                                        child: SingleChildScrollView(
                                          child: Text(
                                            widget.task.note!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
