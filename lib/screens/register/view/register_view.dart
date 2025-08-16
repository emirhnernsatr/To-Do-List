import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/register/cubit/register_state.dart';
import 'package:to_do_uygulamsi/screens/register/model/register_model.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';
import 'package:to_do_uygulamsi/core/constants/app_strings.dart';
import '../cubit/register_cubit.dart';
import '../../login/view/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Padding(
          padding: AppPadding.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppText.registerText,

                AppSpacing.h(60),
                _textFieldRegisterEmail(),

                AppSpacing.h(30),
                _textFieldRegisterPassword(),

                AppSpacing.h(30),
                _textFieldRegisterConfirmPassword(),

                AppSpacing.h(20),

                BlocListener<RegisterCubit, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterSuccess) {
                      Future.delayed(const Duration(seconds: 1), () {
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginView()),
                        );
                      });
                    }
                  },
                  child: BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      if (state is RegisterError) {
                        return Text(
                          state.error,
                          style: const TextStyle(
                            color: AppColors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (state is RegisterSuccess) {
                        return Text(
                          state.message,
                          style: const TextStyle(
                            color: AppColors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                AppSpacing.h(20),
                _registerButton(),

                AppSpacing.h(10),
                _accountPromptButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton _registerButton() {
    return TextButton(
      onPressed: () {
        final model = RegisterModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(),
        );

        context.read<RegisterCubit>().register(model, context);
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.green,
        ),
        child: Center(child: AppText.registerButtonText),
      ),
    );
  }

  TextButton _accountPromptButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      },
      child: AppText.accountPromptText,
    );
  }

  TextField _textFieldRegisterEmail() {
    return TextField(
      controller: emailController,
      decoration: customInputDecoration(
        'Email',
        const Icon(Icons.email, color: AppColors.white),
      ),
      style: const TextStyle(color: AppColors.white),
      cursorColor: AppColors.white,
    );
  }

  TextField _textFieldRegisterPassword() {
    return TextField(
      controller: passwordController,
      decoration: customInputDecoration(
        'Sifre',
        const Icon(Icons.lock, color: AppColors.white),
      ),
      style: const TextStyle(color: AppColors.white),
      cursorColor: AppColors.white,
      obscureText: true,
    );
  }

  TextField _textFieldRegisterConfirmPassword() {
    return TextField(
      controller: confirmPasswordController,
      decoration: customInputDecoration(
        'Sifre Onay',
        const Icon(Icons.lock, color: AppColors.white),
      ),
      style: const TextStyle(color: AppColors.white),
      cursorColor: AppColors.white,
      obscureText: true,
    );
  }

  InputDecoration customInputDecoration(String hintText, dynamic prefixIcon) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.whitecolor),
      filled: true,
      fillColor: Colors.white24,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Colors.white,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Colors.white,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
    );
  }
}
