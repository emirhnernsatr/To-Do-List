import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String title;
  final String? note;
  final bool isCompleted;
  final DateTime? date;
  final TimeOfDay? time;
  final DateTime timestamp;

  TaskModel({
    required this.id,
    required this.title,
    this.note,
    this.isCompleted = false,
    this.date,
    this.time,
    required this.timestamp,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TaskModel(
      id: documentId,
      title: map['title'] ?? '',
      note: map['note'],
      isCompleted: map['isCompleted'] ?? false,
      date: map['date'] != null ? DateTime.tryParse(map['date']) : null,
      time: map['time'] != null ? _parseTimeOfDay(map['time']) : null,
      timestamp: map['timestamp'] ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date?.toIso8601String(),
      'time': time != null ? '${time!.hour}:${time!.minute}' : null,
      'timestamp': timestamp,
    };
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? note,
    bool? isCompleted,
    DateTime? date,
    TimeOfDay? time,
    DateTime? timestamp,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      time: time ?? this.time,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class TaskItemModel {
  final TaskModel taskItem;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;

  const TaskItemModel({
    required this.taskItem,
    required this.onToggleDone,
    required this.onDelete,
  });
}
