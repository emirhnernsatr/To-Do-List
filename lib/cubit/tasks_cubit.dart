import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_uygulamsi/cubit/tasks_state.dart';
import 'package:to_do_uygulamsi/models/task.dart';

class TasksCubit extends Cubit<TasksState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;
  StreamSubscription? _tasksSubscription;

  TasksCubit(this.uid) : super(TasksInitial());

  String _searchQuery = '';

  List<Task> _tasks = [];

  void listenToTasks() {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null || uid.isEmpty) {
      emit(
        TasksError(
          tasks: _tasks,
          message: "UID boş. Oturum açılmamış olabilir.",
        ),
      );
      return;
    }
    emit(TasksLoading(tasks: _tasks));

    _tasksSubscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .snapshots()
        .listen(
          (snaphot) {
            _tasks = snaphot.docs.map((doc) {
              return Task.fromMap(doc.data(), doc.id);
            }).toList();

            _tasks.sort((a, b) {
              if (a.isCompleted != b.isCompleted) {
                return a.isCompleted ? 1 : -1;
              }
              return a.title.toLowerCase().compareTo(b.title.toLowerCase());
            });

            emit(TasksLoaded(_tasks, _searchQuery));
          },
          onError: (error) {
            emit(TasksError(tasks: _tasks, message: "bir hata oluştu"));
          },
        );
  }

  Future<void> addTask(String title) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null || uid.isEmpty) {
      emit(
        TasksError(
          tasks: _tasks,
          message: "UID boş. Oturum açılmamış olabilir.",
        ),
      );
      return;
    }

    emit(TasksLoading(tasks: _tasks));

    try {
      await Future.delayed(Duration(milliseconds: 800));

      final newDoc = _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc();

      final newTask = Task(
        id: newDoc.id,
        title: title,
        userId: uid,
        timestamp: DateTime.now(),

        note: '',
      );

      await newDoc.set(newTask.toMap());

      emit(TasksLoaded(List.from(_tasks), _searchQuery));
    } catch (e) {
      emit(TasksError(tasks: _tasks, message: "Hata: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }

  Future<void> toggleTask(String id) async {
    emit(TasksLoading(tasks: _tasks));

    try {
      await Future.delayed(Duration(milliseconds: 600));

      final index = _tasks.indexWhere((task) => task.id == id);
      if (index == -1) return;

      final updatedTask = _tasks[index].toggle();

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .update(updatedTask.toMap());

      _tasks[index] = updatedTask;

      _tasks.sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      });
    } catch (e) {
      emit(TasksError(tasks: _tasks, message: "bir hata oluştu."));
    }
  }

  Future<void> deleteTask(String id) async {
    emit(TasksLoading(tasks: _tasks));

    try {
      await Future.delayed(Duration(milliseconds: 600));

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .delete();

      _tasks.removeWhere((task) => task.id == id);

      emit(TasksLoaded(List.from(_tasks), _searchQuery));
    } catch (e) {
      emit(
        TasksError(tasks: _tasks, message: "Görev silinirken bir hata oluştu."),
      );
    }
  }

  void filterTasks(String query) {
    _searchQuery = query;
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

      _tasks = snapshot.docs.map((doc) {
        return Task.fromMap(doc.data(), doc.id);
      }).toList();

      emit(TasksLoaded(List.from(_tasks), _searchQuery));
    } catch (e) {
      emit(
        TasksError(tasks: _tasks, message: "Görevler yüklenirken hata oluştu."),
      );
    }
  }

  Future<void> editTask({
    required String id,
    required String newTitle,
    String? newNote,
    DateTime? newDate,
    TimeOfDay? newTime,
  }) async {
    emit(TasksLoading(tasks: _tasks));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _tasks.indexWhere((task) => task.id == id);
      if (index == -1) return;

      final oldTask = _tasks[index];
      final updatedTask = Task(
        id: oldTask.id,
        title: newTitle,
        isCompleted: oldTask.isCompleted,
        userId: oldTask.userId,
        timestamp: oldTask.timestamp,

        note: newNote ?? oldTask.note,
        date: newDate ?? oldTask.date,
        time: newTime ?? oldTask.time,
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .update(updatedTask.toMap());

      _tasks[index] = updatedTask;

      emit(TasksLoaded(List.from(_tasks), _searchQuery));
    } catch (e) {
      emit(
        TasksError(
          tasks: _tasks,
          message: "Görev düzenlenirken bir hata oluştu.",
        ),
      );
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    try {
      emit(TasksLoading(tasks: state.tasks));

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(updatedTask.id)
          .update(updatedTask.toMap());

      final updatedTasks = state.tasks.map((task) {
        return task.id == updatedTask.id ? updatedTask : task;
      }).toList();

      emit(TasksLoaded(updatedTasks, state.searchQuery));
    } catch (e) {
      emit(TasksError(tasks: state.tasks, message: 'Görev güncellenemedi: $e'));
    }
  }
}

class ThemeCubit extends Cubit<bool> {
  static const String prefsKey = 'isDarkMode';

  ThemeCubit() : super(false) {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(prefsKey) ?? false;
    emit(isDark);
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newTheme = !state;
    await prefs.setBool(prefsKey, newTheme);
    emit(newTheme);
  }
}
