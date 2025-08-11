import 'package:to_do_uygulamsi/screens/home/model/task_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<TaskModel> tasks;
  final List<TaskModel> filteredTasks;

  HomeLoaded({required this.tasks, List<TaskModel>? filteredTasks})
    : filteredTasks = filteredTasks ?? tasks;
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
