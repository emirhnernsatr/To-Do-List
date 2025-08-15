import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_state.dart';
import 'package:to_do_uygulamsi/screens/home/model/task_model.dart';

class HomeCubit extends Cubit<HomeState> {
  final String uid;
  HomeCubit(this.uid) : super(HomeInitial()) {
    listenToTasks();
  }

  final List<TaskModel> _tasks = [];

  StreamSubscription? _tasksSubscription;

  Future<void> addTask(String title) async {
    if (uid.isEmpty) {
      emit(HomeError("Kullanıcı oturumu yok."));
      return;
    }

    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      timestamp: DateTime.now(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(newTask.id)
          .set(newTask.toMap());
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> toggleTask(String id) async {
    if (uid.isEmpty) {
      emit(HomeError("Kullanıcı oturumu yok."));
      return;
    }

    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;

    final task = _tasks[index];
    final updatedIsCompleted = !task.isCompleted;

    _tasks[index] = task.copyWith(isCompleted: updatedIsCompleted);
    _tasks.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );

    if (state is HomeLoaded) {
      emit(
        HomeLoaded(tasks: List.from(_tasks), filteredTasks: List.from(_tasks)),
      );
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .update({'isCompleted': updatedIsCompleted});
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> deleteTask(String id) async {
    if (uid.isEmpty) {
      emit(HomeError("Kullanıcı oturumu yok."));
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .delete();
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> editTask({
    required String id,
    String? newTitle,
    String? newNote,
    DateTime? newDate,
    TimeOfDay? newTime,
  }) async {
    if (uid.isEmpty) {
      emit(HomeError("Kullanıcı oturumu yok."));
      return;
    }
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;

    final task = _tasks[index];
    final updatedTask = task.copyWith(
      title: newTitle ?? task.title,
      note: newNote ?? task.note,
      date: newDate ?? task.date,
      time: newTime ?? task.time,
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .update(updatedTask.toMap());
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void filterTasks(String query) {
    if (state is HomeLoaded) {
      final allTasks = (state as HomeLoaded).tasks;
      final filtered = query.isEmpty
          ? allTasks
          : allTasks
                .where(
                  (task) => task.title.toLowerCase().contains(
                    query.toLowerCase().trim(),
                  ),
                )
                .toList();

      emit(HomeLoaded(tasks: allTasks, filteredTasks: filtered));
    }
  }

  Future<void> listenToTasks() async {
    if (uid.isEmpty) {
      emit(HomeError("Kullanıcı oturumu yok."));
      return;
    }
    emit(HomeLoading());

    await _tasksSubscription?.cancel();

    try {
      _tasksSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
              final tasks = snapshot.docs.map((doc) {
                final data = doc.data();
                return TaskModel.fromMap(data, doc.id);
              }).toList();

              tasks.sort((a, b) {
                if (a.isCompleted && !b.isCompleted) {
                  return 1;
                }
                if (!a.isCompleted && b.isCompleted) {
                  return -1;
                }
                return a.title.toLowerCase().compareTo(b.title.toLowerCase());
              });

              _tasks.clear();
              _tasks.addAll(tasks);

              emit(HomeLoaded(tasks: tasks, filteredTasks: tasks));
            },
            onError: (error) {
              emit(HomeError(error.toString()));
            },
          );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
