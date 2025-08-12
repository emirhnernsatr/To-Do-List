import 'package:cloud_firestore/cloud_firestore.dart';
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
    final ts = map['timestamp'] as Timestamp?;
    final dateTs = map['date'] as Timestamp?;

    return TaskModel(
      id: documentId,
      title: map['title'] ?? '',
      note: map['note'],
      isCompleted: map['isCompleted'] ?? false,
      date: dateTs?.toDate(),
      time: map['time'] != null
          ? (map['time'] is String
                ? _parseTimeOfDay(map['time'])
                : TimeOfDay(
                    hour: map['time']['hour'] ?? 0,
                    minute: map['time']['minute'] ?? 0,
                  ))
          : null,
      timestamp: ts != null ? ts.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'time': time != null ? '${time!.hour}:${time!.minute}' : null,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      isCompleted: json['isCompleted'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      time: json['time'] != null ? _parseTimeOfDay(json['time']) : null,
      timestamp: DateTime.tryParse(json['timestamp']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date?.toIso8601String(),
      'time': time != null ? '${time!.hour}:${time!.minute}' : null,
      'timestamp': timestamp.toIso8601String(),
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
