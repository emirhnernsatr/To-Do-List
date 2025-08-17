import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_cubit.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_state.dart';
import 'package:to_do_uygulamsi/screens/home/widget/task_item.dart';
import 'package:to_do_uygulamsi/screens/login/view/login_view.dart';
import 'package:to_do_uygulamsi/core/service/auth_service.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';
import 'package:to_do_uygulamsi/core/theme/cubit/theme_cubit.dart';
import 'package:to_do_uygulamsi/core/constants/app_strings.dart';

class HomeView extends StatefulWidget {
  final String uid;
  const HomeView({super.key, required this.uid});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
  final AuthService authService = AuthService();
  late HomeCubit _homeCubit;

  void _logout() async {
    await authService.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _homeCubit = HomeCubit(widget.uid);

    _searchController.addListener(() {
      _homeCubit.filterTasks(_searchController.text);
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
    // ignore: unrelated_type_equality_checks
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider.value(
      value: _homeCubit,
      child: Scaffold(
        appBar: AppBar(
          title: AppText.titleHomeText,
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
          leading: _exitIcon(),
        ),

        body: Padding(
          padding: AppPadding.all(16),
          child: Column(
            children: [
              _textFieldSearch(),
              AppSpacing.h(16),

              const Expanded(child: TaskListView()),
            ],
          ),
        ),
        floatingActionButton: _addTaskDialogButton(context),
      ),
    );
  }

  Widget _addTaskDialogButton(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () => _showAddTaskDialog(context),
          child: const Icon(Icons.add, color: AppColors.white, size: 30),
        );
      },
    );
  }

  TextField _textFieldSearch() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.primaryColor,
          size: 30,
        ),
        hintText: 'Ara',
        hintStyle: const TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        labelStyle: const TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
    );
  }

  IconButton _exitIcon() {
    return IconButton(
      onPressed: _logout,
      icon: const Icon(Icons.logout),
      color: AppColors.whitecolor,
      tooltip: 'Çıkış Yap',
    );
  }
}

void _showAddTaskDialog(BuildContext c) {
  final newTaskController = TextEditingController();

  showDialog(
    context: c,
    builder: (context) {
      return AlertDialog(
        title: AppText.addNewTaskText,
        content: TextField(
          controller: newTaskController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Görev adı',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
          ),
          onSubmitted: (_) => _submitTask(c, newTaskController),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AppText.cancelText,
          ),
          ElevatedButton(
            onPressed: () => _submitTask(c, newTaskController),
            child: AppText.addText,
          ),
        ],
      );
    },
  );
}

void _submitTask(BuildContext context, TextEditingController controller) {
  final text = controller.text.trim();
  if (text.isNotEmpty) {
    context.read<HomeCubit>().addTask(text);
    Navigator.of(context).pop();
  }
}
