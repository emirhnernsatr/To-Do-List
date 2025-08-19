import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_cubit.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_state.dart';
import 'package:to_do_uygulamsi/screens/home/widget/task_detail_widgets.dart';
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
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider.value(
      value: _homeCubit,
      child: Scaffold(
        appBar: AppBar(
          title: AppText.titleHomeText,
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
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
          onPressed: () => _showAddTaskBottomSheet(context),
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

  void _showAddTaskBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final noteController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final isDark =
            // ignore: unrelated_type_equality_checks
            context.watch<ThemeCubit>().state == ThemeMode.dark;
        return Padding(
          padding: AppPadding.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Görev Ekle',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    AppSpacing.h(16),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        String? errorText;

                        if (state is HomeError) {
                          errorText = state.message;
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            taskTitleTextField(
                              controller: titleController,
                              isDark: isDark,
                            ),

                            if (errorText != null)
                              Padding(
                                padding: AppPadding.only(top: 6),
                                child: Text(
                                  errorText,
                                  style: const TextStyle(
                                    color: AppColors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    AppSpacing.h(16),

                    Row(
                      children: [
                        Expanded(
                          child: dateTextfield(
                            isDark: isDark,
                            selectedDate: selectedDate,
                            onTap: () async {
                              final piced = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (piced != null) {
                                setState(() => selectedDate = piced);
                              }
                            },
                          ),
                        ),
                        AppSpacing.h(20),
                        AppSpacing.w(8),
                        Expanded(
                          child: timeTextfield(
                            context: context,
                            isDark: isDark,
                            selectedTime: selectedTime,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() => selectedTime = picked);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.h(16),
                    noteTextfield(
                      controller: noteController,
                      isDark: isDark,
                      maxLine: 5,
                    ),
                    AppSpacing.h(20),
                    SizedBox(
                      width: double.infinity,
                      child: saveElevatedButtton(
                        onPressed: () {
                          if (titleController.text.trim().isEmpty) return;

                          context.read<HomeCubit>().addTask(
                            title: titleController.text.trim(),
                            note: noteController.text.trim(),
                            date: selectedDate ?? DateTime.now(),
                            time: selectedTime ?? TimeOfDay.now(),
                          );

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
