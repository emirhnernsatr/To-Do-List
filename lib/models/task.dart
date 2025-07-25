import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final String? userId;
  final DateTime? timestamp;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.userId,
    this.timestamp,
  });

  Task toggle() {
    return Task(
      id: id,
      title: title,
      isCompleted: !isCompleted,
      userId: userId,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'userId': userId,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      userId: map['userId'],
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : null,
    );
  }
}
