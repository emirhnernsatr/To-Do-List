import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_state.dart';
import 'package:to_do_uygulamsi/screens/home/model/task_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final List<TaskModel> _tasks = [];

  StreamSubscription? _tasksSubscription;

  void addTask(String title) {
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      timestamp: DateTime.now(),
    );
    _tasks.add(newTask);
    emit(HomeLoaded(tasks: List.from(_tasks)));
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      emit(HomeLoaded(tasks: List.from(_tasks)));
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    emit(HomeLoaded(tasks: List.from(_tasks)));
  }

  void editTask({
    required String id,
    String? newTitle,
    String? newNote,
    DateTime? newDate,
    TimeOfDay? newTime,
  }) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(
        title: newTitle ?? task.title,
        note: newNote ?? task.note,
        date: newDate ?? task.date,
        time: newTime ?? task.time,
      );
      emit(HomeLoaded(tasks: List.from(_tasks)));
    }
  }

  void filterTasks(String query) {
    if (state is HomeLoaded) {
      final allTasks = (state as HomeLoaded).tasks;
      final filtered = allTasks
          .where(
            (task) =>
                task.title.toLowerCase().contains(query.toLowerCase().trim()),
          )
          .toList();
      emit(HomeLoaded(tasks: allTasks, filteredTasks: filtered));
    }
  }

  Future<void> listenToTasks() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
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

              emit(HomeLoaded(tasks: tasks));
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
