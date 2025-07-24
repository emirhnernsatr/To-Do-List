import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final String? userId;
  final DateTime? timetamp;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.userId,
    this.timetamp,
  });

  Task toggle() {
    return Task(
      id: id,
      title: title,
      isCompleted: !isCompleted,
      userId: userId,
      timetamp: timetamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'userId': userId,
      'timestamp': timetamp ?? FieldValue.serverTimestamp(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      userId: map['userId'],
      timetamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : null,
    );
  }
}
