import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final String? userId;
  final DateTime? timeTamp;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.userId,
    this.timeTamp,
  });

  Task toggle() {
    return Task(
      id: id,
      title: title,
      isCompleted: !isCompleted,
      userId: userId,
      timeTamp: timeTamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'userId': userId,
      'timesTamp': timeTamp ?? FieldValue.serverTimestamp(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      userId: map['userId'],
      timeTamp: map['timesTamp'] != null
          ? (map['timesTamp'] as Timestamp).toDate()
          : null,
    );
  }
}
