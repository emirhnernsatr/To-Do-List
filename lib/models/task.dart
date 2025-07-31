import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final String userId;
  final DateTime timestamp;
  final String? note;
  final DateTime? date;
  final TimeOfDay? time;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.userId,
    required this.timestamp,
    this.note,
    this.date,
    this.time,
  });

  Task toggle() {
    return Task(
      id: id,
      title: title,
      isCompleted: !isCompleted,
      userId: userId,
      timestamp: timestamp,
      note: note,
      date: date,
      time: time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'userId': userId,
      'timestamp': Timestamp.fromDate(timestamp),
      'note': note ?? '',
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'time': time != null
          ? {'hour': time!.hour, 'minute': time!.minute}
          : null,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    TimeOfDay? parsedTime;
    if (map['time'] != null &&
        map['time'] is Map &&
        map['time']['hour'] != null &&
        map['time']['minute'] != null) {
      parsedTime = TimeOfDay(
        hour: map['time']['hour'],
        minute: map['time']['minute'],
      );
    }

    return Task(
      id: id,
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      userId: map['userId'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),

      note: map['note'],
      date: map['date'] != null ? (map['date'] as Timestamp).toDate() : null,
      time: parsedTime,
    );
  }
}
