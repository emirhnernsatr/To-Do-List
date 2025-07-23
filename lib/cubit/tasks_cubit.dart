import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/cubit/tasks_state.dart';
import 'package:to_do_uygulamsi/models/task.dart';

class TasksCubit extends Cubit<TasksState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;

  TasksCubit(this.uid) : super(TasksInitial());

  List<Task> _tasks = [];

  Future<void> addTask(String title) async {
    emit(TasksLoading(tasks: _tasks));

    try {
      await Future.delayed(Duration(milliseconds: 800));

      final newTask = Task(
        id: FirebaseFirestore.instance.collection('tmp').doc().id,
        title: title,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc('newTask.id')
          .set(newTask.toMap());

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

      final index = _tasks.indexWhere((task) => task.id == id);
      if (index == -1) return;

      final updatedTask = _tasks[index].toggle();
      _tasks[index] = updatedTask;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .update(updatedTask.toMap());

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

  Future<void> loadInitialTasks() async {
    emit(TasksLoading(tasks: _tasks));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .get();

      _tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();

      emit(TasksLoaded(List.from(_tasks), ''));
    } catch (e) {
      emit(
        TasksError(tasks: _tasks, message: "Görevler yüklenirken hata oluştu."),
      );
    }
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
