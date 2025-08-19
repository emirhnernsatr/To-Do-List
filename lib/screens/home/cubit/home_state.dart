import 'package:to_do_uygulamsi/screens/home/model/task_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<TaskModel> tasks;
  final List<TaskModel> filteredTasks;

  HomeLoaded({required this.tasks, List<TaskModel>? filteredTasks})
    : filteredTasks = filteredTasks ?? tasks;

  HomeLoaded copyWith({
    List<TaskModel>? tasks,
    List<TaskModel>? filteredTasks,
  }) {
    return HomeLoaded(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
    );
  }
}

class HomeTaskUpdated extends HomeState {
  final List<TaskModel>? tasks;
  HomeTaskUpdated({this.tasks});
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
