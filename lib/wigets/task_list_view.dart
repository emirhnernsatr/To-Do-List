import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart'; // Burada modelin konumunu kendi projenle uyumlu hale getir

class TaskListView extends StatelessWidget {
  final String uid;

  const TaskListView({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (uid.isEmpty) {
      return const Center(child: Text("Kullanıcı oturumu açık değil"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Veriler yüklenirken hata oluştu."));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Henüz görev yok."));
        }

        final tasks = snapshot.data!.docs.map((doc) {
          return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];

            return ListTile(
              title: Text(task.title),
              leading: Icon(
                task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: task.isCompleted ? Colors.green : Colors.grey,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('tasks')
                      .doc(task.id)
                      .delete();
                },
              ),
              onTap: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('tasks')
                    .doc(task.id)
                    .update({'isCompleted': !task.isCompleted});
              },
            );
          },
        );
      },
    );
  }
}
