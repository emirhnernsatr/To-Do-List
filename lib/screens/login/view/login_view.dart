import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/core/service/auth_service.dart';
import 'package:to_do_uygulamsi/screens/forgot_password/view/forgot_password_view.dart';
import 'package:to_do_uygulamsi/screens/login/cubit/login_cubit.dart';
import 'package:to_do_uygulamsi/screens/login/cubit/login_state.dart';
import 'package:to_do_uygulamsi/screens/login/model/login_model.dart';
import 'package:to_do_uygulamsi/screens/register/cubit/register_cubit.dart';
import 'package:to_do_uygulamsi/screens/register/view/register_view.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';
import 'package:to_do_uygulamsi/widgets/task_item.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: Paddings.all40,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppText.titleText,
                sizedBoxH(40),
                _textFieldEmail(),

                sizedBoxH(20),
                _textFieldLoginPassword(),

                sizedBoxH(30),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state is LoginError) {
                      return Text(
                        state.error,
                        style: const TextStyle(
                          color: AppColors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (state is LoginSuccess) {
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
                sizedBoxH(20),
                _homeButton(context),

                sizedBoxH(20),
                _forgotPasswordButton(context),
                _registerButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton _homeButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        final model = LoginModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        context.read<LoginCubit>().login(model, context);
      },
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: AppColors.green,
        ),
        child: Center(child: AppText.loginText),
      ),
    );
  }

  TextButton _registerButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => RegisterCubit(AuthService()),
              child: const RegisterView(),
            ),
          ),
        );
      },
      child: AppText.registerLinkText,
    );
  }

  TextButton _forgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ForgotPasswordView()),
        );
      },
      child: AppText.forgotPasswordText,
    );
  }

  TextField _textFieldEmail() {
    return TextField(
      controller: emailController,
      decoration: customInputDecoration('Email'),
      cursorColor: AppColors.whitecolor,
      style: const TextStyle(color: AppColors.whitecolor),
      keyboardType: TextInputType.emailAddress,
    );
  }

  TextField _textFieldLoginPassword() {
    return TextField(
      controller: passwordController,
      decoration: customInputDecoration('Sifre'),
      cursorColor: AppColors.whitecolor,
      obscureText: true,
      style: const TextStyle(color: AppColors.whitecolor),
    );
  }

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.whitecolor),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.whitecolor),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.whitecolor),
      ),
    );
  }
}
