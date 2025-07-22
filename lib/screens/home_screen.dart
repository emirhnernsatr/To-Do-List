import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/cubit/tasks_cubit.dart';

class Task {
  String title;
  bool isDone;

  Task({required this.title, this.isDone = false});
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTasks);
    _filteredTasks = _tasks;
  }

  @override
  void dispose() {
    _taskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterTasks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTasks = _tasks;
      } else {
        _filteredTasks = _tasks
            .where((task) => task.title.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _addTask() {
    final text = _taskController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(title: text));
        _taskController.clear();
        _filterTasks();
      });
    }
  }

  void _toggleTaskDone(Task task) {
    setState(() {
      task.isDone = !task.isDone;
      _filterTasks();
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
      _filterTasks();
    });
  }

  void _editTask(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        final editController = TextEditingController(text: task.title);
        return AlertDialog(
          title: Text('Görevi Düzenle'),
          content: TextField(
           // onChanged: (value) => context.read()<TasksCubit>().,
            controller: editController,
            autofocus: true,
            decoration: InputDecoration(labelText: 'Yeni Başlık'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                final newTitle = editController.text.trim();
                if (newTitle.isNotEmpty) {
                  setState(() {
                    task.title = newTitle;
                    _filterTasks();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Görev Listesi'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Görev ekleme satırı
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'Yeni görev',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(onPressed: _addTask, child: Text('Ekle')),
              ],
            ),

            SizedBox(height: 16),

            // Arama çubuğu
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Ara',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            // Görev listesi
            Expanded(
              child: _filteredTasks.isEmpty
                  ? Center(child: Text('Görev bulunamadı'))
                  : ListView.builder(
                      itemCount: _filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];
                        return TaskItem(
                          task: task,
                          onToggleDone: () => _toggleTaskDone(task),
                          onDelete: () => _deleteTask(task),
                          onEdit: () => _editTask(task),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onToggleDone,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: task.isDone, onChanged: (_) => onToggleDone()),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.grey),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
