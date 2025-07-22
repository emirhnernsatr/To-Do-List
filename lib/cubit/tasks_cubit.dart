import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/cubit/tasks_state.dart';
import 'package:to_do_uygulamsi/models/task.dart';

class TasksCubit extends Cubit<TasksState> {
  final String uid;

  TasksCubit(this.uid) : super(TasksInitial());

  List<Task> _tasks = [];

  Future<void> addTask(String title) async {
    emit(TasksLoading(tasks: _tasks));

    try {
      await Future.delayed(Duration(milliseconds: 800));

      final newTask = Task(id: UniqueKey().toString(), title: title);
      _tasks.add(newTask);

      emit(TasksLoaded(List.from(_tasks), ""));
    } catch (e) {
      emit(
        TasksError(tasks: _tasks, message: "Görev silinirken bir hata oluştu."),
      );
    }
  }

  Future<void> toggleTask(String id) async {
    emit(TasksLoading(tasks: _tasks));

    try {
      await Future.delayed(Duration(milliseconds: 600));

      _tasks = _tasks.map((task) {
        return task.id == id ? task.toggle() : task;
      }).toList();

      emit(TasksLoaded(List.from(_tasks), ""));
    } catch (e) {
      emit(
        TasksError(tasks: _tasks, message: "Görev silinirken bir hata oluştu."),
      );
    }
  }

  Future<void> deleteTask(String id) async {
    emit(TasksLoading(tasks: _tasks));

    try {
      await Future.delayed(Duration(milliseconds: 600));

      _tasks.removeWhere((task) => task.id == id);

      emit(TasksLoaded(List.from(_tasks), ""));
    } catch (e) {
      emit(
        TasksError(tasks: _tasks, message: "Görev silinirken bir hata oluştu."),
      );
    }
  }

  void filterTasks(String query) {
    emit(TasksLoaded(List.from(_tasks), query));
  }

  void loadInitialTasks() {
    emit(TasksLoaded(List.from(_tasks), ""));
  }

  Future<void> editTask(String id, String newTitle) async {
    emit(TasksLoading(tasks: _tasks));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _tasks = _tasks.map((task) {
        return task.id == id
            ? Task(id: task.id, title: newTitle, isCompleted: task.isCompleted)
            : task;
      }).toList();

      emit(TasksLoaded(List.from(_tasks), ""));
    } catch (e) {
      emit(
        TasksError(
          tasks: _tasks,
          message: "Görev düzenlenirken bir hata oluştu.",
        ),
      );
    }
  }
}
