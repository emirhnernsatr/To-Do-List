class Task {
  final String id;
  final String title;
  final bool isCompleted;

  Task({required this.id, required this.title, this.isCompleted = false});

  Task toggle() {
    return Task(id: id, title: title, isCompleted: !isCompleted);
  }
}
