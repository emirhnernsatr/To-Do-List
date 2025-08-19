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

  Future<void> addTask({
    required String title,
    required String note,
    required DateTime date,
    required TimeOfDay time,
  }) async {
    if (uid.isEmpty) {
      _emitWithAutoClear(HomeError("Kullanıcı oturumu yok."));
      return;
    }
    if (title.trim().isEmpty) {
      _emitWithAutoClear(HomeError('Görev başlığı boş olamaz'));
      return;
    }

    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      note: note,
      date: date,
      time: time,
      isCompleted: false,
      timestamp: DateTime.now(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(newTask.id)
          .set(newTask.toMap());

      _tasks.add(newTask);
      _tasks.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );

      emit(
        HomeLoaded(tasks: List.from(_tasks), filteredTasks: List.from(_tasks)),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> toggleTask(String id) async {
    if (uid.isEmpty) {
      _emitWithAutoClear(HomeError("Kullanıcı oturumu yok."));
      return;
    }

    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;

    final task = _tasks[index];
    final updatedIsCompleted = !task.isCompleted;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .update({'isCompleted': updatedIsCompleted});

      _tasks[index] = task.copyWith(isCompleted: updatedIsCompleted);
      _tasks.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );

      if (state is HomeLoaded) {
        emit(
          HomeLoaded(
            tasks: List.from(_tasks),
            filteredTasks: List.from(_tasks),
          ),
        );
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> deleteTask(String id) async {
    if (uid.isEmpty) {
      _emitWithAutoClear(HomeError("Kullanıcı oturumu yok."));
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

  void filterTasks(String query) {
    final current = state;
    if (current is! HomeLoaded) return;

    final all = current.tasks;
    final q = query.trim();
    if (q.isEmpty) {
      emit(HomeLoaded(tasks: all, filteredTasks: all));
      return;
    }

    String norm(String s) =>
        s.toLowerCase().replaceAll('İ', 'i').replaceAll('I', 'ı');

    final nq = norm(q);
    final filtered = all.where((t) => norm(t.title).contains(nq)).toList();

    emit(HomeLoaded(tasks: all, filteredTasks: filtered));
  }

  Future<void> listenToTasks() async {
    if (uid.isEmpty) {
      _emitWithAutoClear(HomeError("Kullanıcı oturumu yok."));
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
                if (a.isCompleted && !b.isCompleted) return 1;
                if (!a.isCompleted && b.isCompleted) return -1;
                return a.title.toLowerCase().compareTo(b.title.toLowerCase());
              });

              _tasks
                ..clear()
                ..addAll(tasks);

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

  void _emitWithAutoClear(HomeState state) {
    emit(state);
    Future.delayed(const Duration(seconds: 3), () {
      if (!isClosed) {
        emit(HomeInitial());
      }
    });
  }

  Future<void> newTaskChanges({
    required String id,
    required String newTitle,
    required String newNote,
    required DateTime newDate,
    required TimeOfDay newTime,
  }) async {
    if (newTitle.trim().isEmpty) {
      _emitWithAutoClear(HomeError('Görev başlığı boş olamaz'));
      return;
    }

    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;

    final task = _tasks[index];
    final updatedTask = task.copyWith(
      title: newTitle,
      note: newNote,
      date: newDate,
      time: newTime,
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .update(updatedTask.toMap());

      _tasks[index] = updatedTask;

      emit(
        HomeLoaded(tasks: List.from(_tasks), filteredTasks: List.from(_tasks)),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
