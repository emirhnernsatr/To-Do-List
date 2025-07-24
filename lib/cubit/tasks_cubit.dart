import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    if (uid.isEmpty) {
      emit(
        TasksError(
          tasks: _tasks,
          message: "UID bos . Oturum acılmamıs olabılır.",
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

            emit(TasksLoaded(_tasks, _searchQuery));
          },
          onError: (error) {
            emit(TasksError(tasks: _tasks, message: "bir hata oluştu"));
          },
        );
  }

  Future<void> addTask(String title) async {
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
        timetamp: DateTime.now(),
      );

      await newDoc.set(newTask.toMap());

      emit(TasksLoaded(List.from(_tasks), _searchQuery));
    } catch (e) {
      print("Firestore Hatası: $e");
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

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .update(updatedTask.toMap());

      emit(TasksLoaded(List.from(_tasks), _searchQuery));
    } catch (e) {
      emit(TasksError(tasks: _tasks, message: "bir hata oluştu."));
    }
  }

  Future<void> deleteTask(String id) async {
    emit(TasksLoading(tasks: _tasks));

    try {
      await Future.delayed(Duration(milliseconds: 600));

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .delete();

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
        final data = doc.data();
        return Task.fromMap(doc.data(), doc.id);
      }).toList();

      emit(TasksLoaded(List.from(_tasks), _searchQuery));
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

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(id)
          .update({'title': newTitle});

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
}
