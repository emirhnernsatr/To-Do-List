import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_cubit.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_state.dart';
import 'package:to_do_uygulamsi/screens/home/widget/task_item_widget.dart';
import 'package:to_do_uygulamsi/core/constants/app_strings.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
          final tasks = state.filteredTasks;

          if (tasks.isEmpty) {
            return Center(child: AppText.noMissionsYetText);
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return TaskItemWidget(
                task: task,
                onToggleDone: () =>
                    context.read<HomeCubit>().toggleTask(task.id),
                onDelete: () => context.read<HomeCubit>().deleteTask(task.id),
              );
            },
          );
        } else if (state is HomeError) {
          return Center(child: Text('Hata: ${state.message}'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
