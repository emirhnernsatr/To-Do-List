import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:to_do_uygulamsi/screens/forgot_password/cubit/forgot_password_state.dart';
import 'package:to_do_uygulamsi/screens/forgot_password/model/forgot_password_model.dart';
import 'package:to_do_uygulamsi/screens/login/view/login_view.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';
import 'package:to_do_uygulamsi/core/constants/app_strings.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(ForgotPasswordService()),
      child: _ForgotPasswordViewBody(),
    );
  }
}

class _ForgotPasswordViewBody extends StatefulWidget {
  @override
  State<_ForgotPasswordViewBody> createState() =>
      _ForgotPasswordViewBodyState();
}

class _ForgotPasswordViewBodyState extends State<_ForgotPasswordViewBody> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Padding(
          padding: AppPadding.all(40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.titleForgotPasswordText,

                AppSpacing.h(40),
                BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                  builder: (context, state) {
                    String? errorText;
                    String? infoText;

                    if (state is ForgotPasswordFailure) {
                      errorText = state.error;
                    } else if (state is ForgotPasswordSuccess) {
                      infoText = state.message;

                      Future.delayed(const Duration(seconds: 1), () {
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginView()),
                        );
                      });
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _textFieldForgotEmail(),
                        AppSpacing.h(20),

                        if (errorText != null)
                          Padding(
                            padding: AppPadding.only(top: 6),
                            child: Text(
                              errorText,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (infoText != null)
                          Padding(
                            padding: AppPadding.only(top: 6),
                            child: Text(
                              infoText,
                              style: const TextStyle(
                                color: AppColors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                AppSpacing.h(20),
                _resetPasswordButton(),

                AppSpacing.h(20),
                _returnLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _textFieldForgotEmail() {
    return TextField(
      controller: emailController,
      decoration: _customInputDecoration(
        "Email",
        const Icon(Icons.email, color: AppColors.white),
      ),
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

  InputDecoration _customInputDecoration(String hintText, dynamic prefixIcon) {
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
