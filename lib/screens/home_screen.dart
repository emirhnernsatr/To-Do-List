import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/login_screen.dart';
import 'package:to_do_uygulamsi/service/auth_service.dart';
import 'package:to_do_uygulamsi/theme/app_theme.dart';
import 'package:to_do_uygulamsi/widgets/task_item.dart';
import 'package:to_do_uygulamsi/widgets/task_list_view.dart';
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: AppText.TitleHomeText,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: AppColors.whitecolor,
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
        centerTitle: true,
        leading: _ExitIcon(),
      ),

      body: Padding(
        padding: Paddings.all16,
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
            _TextFieldSearch(),
            sizedBoxH(16),

            Expanded(child: TaskListView()),
          ],
        ),
      ),
      floatingActionButton: _AddTaskDialogButton(context),
    );
  }

  FloatingActionButton _AddTaskDialogButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primaryColor,
      onPressed: () => _showAddTaskDialog(context),
      child: const Icon(Icons.add, color: AppColors.white, size: 30),
    );
  }

  TextField _TextFieldSearch() {
    return TextField(
      controller: _searchController,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: AppColors.primaryColor, size: 30),
        hintText: 'Ara',
        hintStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        labelStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
    );
  }

  IconButton _ExitIcon() {
    return IconButton(
      onPressed: _logout,
      icon: Icon(Icons.logout),
      color: AppColors.whitecolor,
      tooltip: 'Çıkış Yap',
    );
  }
}

void _showAddTaskDialog(BuildContext dialogContext) {
  final _newTaskController = TextEditingController();

  showDialog(
    context: dialogContext,
    builder: (context) {
      return AlertDialog(
        title: AppText.AddNewTaskText,
        content: TextField(
          controller: _newTaskController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Görev adı',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
          ),
          onSubmitted: (_) => _submitTask(context, _newTaskController),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AppText.CancelText,
          ),
          ElevatedButton(
            onPressed: () => _submitTask(context, _newTaskController),
            child: AppText.AddText,
          ),
        ],
      );
    },
  );
}

void _submitTask(BuildContext context, TextEditingController controller) {
  final text = controller.text.trim();
  if (text.isNotEmpty) {
    context.read<TasksCubit>().addTask(text);
    Navigator.of(context).pop();
  }
}
