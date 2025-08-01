import 'dart:convert';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
      'date': date?.toIso8601String(),
      'time': time != null
          ? {'hour': time!.hour, 'minute': time!.minute}
          : null,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parsedTime;
    if (json['time'] != null) {
      parsedTime = TimeOfDay(
        hour: json['time']['hour'],
        minute: json['time']['minute'],
      );
    }

    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      userId: json['userId'],
      timestamp: DateTime.parse(json['timestamp']),
      note: json['note'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: parsedTime,
    );
  }

  static String encode(List<Task> tasks) => json.encode(
    tasks.map<Map<String, dynamic>>((task) => task.toJson()).toList(),
  );

  static List<Task> decode(String tasksJson) =>
      (json.decode(tasksJson) as List<dynamic>)
          .map<Task>((item) => Task.fromJson(item))
          .toList();
}
