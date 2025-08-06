import 'package:to_do_uygulamsi/models/task.dart';

abstract class TasksState {
  final List<Task> tasks;
  final String searchQuery;

  TasksState({required this.tasks, this.searchQuery = ''});
}

class TasksInitial extends TasksState {
  TasksInitial() : super(tasks: []);
}

class TasksLoading extends TasksState {
  final String message;

  TasksLoading({this.message = "Yükleniyor...", required super.tasks});
}

class TasksLoaded extends TasksState {
  @override
  // ignore: overridden_fields
  final List<Task> tasks;
  @override
  // ignore: overridden_fields
  final String searchQuery;

  TasksLoaded(this.tasks, this.searchQuery)
    : super(tasks: tasks, searchQuery: searchQuery);

  List<Task> get filteredTasks {
    if (searchQuery.isEmpty) return tasks;
    return tasks
        .where(
          (task) =>
              task.title.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }
}

class TasksError extends TasksState {
  final String message;

  TasksError({required super.tasks, this.message = "Bir hata oluştu"});
}
