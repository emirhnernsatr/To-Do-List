import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/login_screen.dart';
import 'package:to_do_uygulamsi/service/auth_service.dart';
import 'package:to_do_uygulamsi/wigets/task_list_view.dart';
import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
  final AuthService _authService = AuthService();

  void _logout() async {
    await _authService.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().listenToTasks();
    _searchController.addListener(() {
      context.read<TasksCubit>().filterTasks(_searchController.text);
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addTask() {
    final text = _taskController.text.trim();
    if (text.isNotEmpty) {
      context.read<TasksCubit>().addTask(text);
      _taskController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görev Listesi'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _logout,
          icon: Icon(Icons.logout),
          tooltip: 'Çıkış Yap',
        ),

        /*IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),*/
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                if (state is TasksError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  });
                }
                return const SizedBox.shrink();
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      labelText: 'Yeni görev',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                BlocBuilder<TasksCubit, TasksState>(
                  builder: (context, state) {
                    final isLoading = state is TasksLoading;

                    return ElevatedButton.icon(
                      onPressed: isLoading ? null : _addTask,
                      label: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Ekle'),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Ara',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: TaskListView()),
          ],
        ),
      ),
    );
  }
}
