import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/cubit/tasks_state.dart';
import 'package:to_do_uygulamsi/models/task.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  List<Task> _tasks = [];
  //final String searchQuery;

  Future<void> addTask(String title) async {
    emit(TasksLoading(tasks: []));

    try {
      await Future.delayed(Duration(milliseconds: 800));

      final newTask = Task(id: UniqueKey().toString(), title: title);
      _tasks.add(newTask);

      emit(TasksLoaded(List.from(_tasks), ""));
    } catch (e) {
      emit(TasksError("Görev silinirken bir hata oluştu."));
    }
  }

  Future<void> toggleTask(String id) async {
    emit(TasksLoading(tasks: []));

    try {
      await Future.delayed(Duration(milliseconds: 600));

      _tasks = _tasks.map((task) {
        return task.id == id ? task.toggle() : task;
      }).toList();

      emit(TasksLoaded(List.from(_tasks), ""));
    } catch (e) {
      emit(TasksError("Görev durumu değiştirilirken hata oluştu."));
    }
  }

  void loadInitialTasks() {
    emit(TasksLoaded(_tasks, ""));
  }
}
