import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:to_do_uygulamsi/screens/forgot_password/cubit/forgot_password_state.dart';
import 'package:to_do_uygulamsi/screens/forgot_password/model/forgot_password_model.dart';
import 'package:to_do_uygulamsi/screens/login/view/login_view.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';
import 'package:to_do_uygulamsi/widgets/task_item.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(ForgotPasswordService()),
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              _showMessage(state.message);
              context.read<ForgotPasswordCubit>().resetState();
            } else if (state is ForgotPasswordFailure) {
              _showMessage(state.error);
            }
          },
          child: Center(
            child: Padding(
              padding: Paddings.all40,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText.titleForgotPasswordText,

                    sizedBoxH(40),
                    _textFieldForgotEmail(),

                    sizedBoxH(30),
                    _resetPasswordButton(),

                    sizedBoxH(20),
                    _returnLoginButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _resetPasswordButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryColor,
      ),
      onPressed: () {
        final model = ForgotPasswordModel(email: emailController.text.trim());
        context.read<ForgotPasswordCubit>().resetPassword(model, context);
      },
      child: AppText.sendResetLinkText,
    );
  }

  TextButton _returnLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      ),
      child: AppText.returnLoginScreenText,
    );
  }

  TextField _textFieldForgotEmail() {
    return TextField(
      controller: emailController,
      decoration: _customInputDecoration("Email"),
      cursorColor: AppColors.white,
      style: const TextStyle(color: AppColors.white),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) {
        final model = ForgotPasswordModel(email: emailController.text.trim());
        context.read<ForgotPasswordCubit>().resetPassword(model, context);
      },
    );
  }

  InputDecoration _customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.white),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.white),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.white),
      ),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
