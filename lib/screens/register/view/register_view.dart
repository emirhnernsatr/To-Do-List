import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/register/cubit/register_state.dart';
import 'package:to_do_uygulamsi/screens/register/model/register_model.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';
import 'package:to_do_uygulamsi/widgets/task_item.dart';
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
          padding: Paddings.all50,
          child: SingleChildScrollView(
            child: Column(
              children: [
                sizedBoxH(50),
                AppText.registerText,

                sizedBoxH(70),
                _textFieldRegisterEmail(),

                sizedBoxH(30),
                _textFieldRegisterPassword(),

                sizedBoxH(30),
                _textFieldRegisterConfirmPassword(),

                sizedBoxH(20),

                BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    if (state is RegisterError) {
                      return Text(
                        state.error,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (state is RegisterSuccess) {
                      return Text(
                        state.message,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                sizedBoxH(20),
                _registerButton(),

                sizedBoxH(20),
                _accountPromptButton(context),

                sizedBoxH(20),
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
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 60),
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
      decoration: customInputDecoration('Email'),
      style: const TextStyle(color: AppColors.white),
      cursorColor: AppColors.white,
    );
  }

  TextField _textFieldRegisterPassword() {
    return TextField(
      controller: passwordController,
      decoration: customInputDecoration('Sifre'),
      style: const TextStyle(color: AppColors.white),
      cursorColor: AppColors.white,
      obscureText: true,
    );
  }

  TextField _textFieldRegisterConfirmPassword() {
    return TextField(
      controller: confirmPasswordController,
      decoration: customInputDecoration('Sifre Onay'),
      style: const TextStyle(color: AppColors.white),
      cursorColor: AppColors.white,
      obscureText: true,
    );
  }

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.white),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.white),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.white),
      ),
    );
  }
}
