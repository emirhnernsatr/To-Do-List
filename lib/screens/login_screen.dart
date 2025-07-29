import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/cubit/tasks_cubit.dart';
import 'package:to_do_uygulamsi/screens/forgot_password_screen.dart';
import 'package:to_do_uygulamsi/screens/home_screen.dart';
import 'package:to_do_uygulamsi/screens/register_screen.dart';
import 'package:to_do_uygulamsi/service/auth_service.dart';
import 'package:to_do_uygulamsi/theme/app_theme.dart';
import 'package:to_do_uygulamsi/widgets/task_item.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String message = '';

  void _login() async {
    final user = await _authService.signInWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      if (user != null) {
        message = 'Giriş başarılı! Hoşgeldin: ${user.email}';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => TasksCubit(user.uid)..listenToTasks(),
              child: const HomeScreen(),
            ),
          ),
        );
      } else {
        message = 'Giriş başarısız!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: Paddings.all50,
            child: Column(
              children: [
                sizedBoxH(50),

                Container(child: AppText.TitleText),
                sizedBoxH(70),

                _TextFieldEmail(),
                sizedBoxH(30),

                _TextFieldSifre(),
                sizedBoxH(20),

                Center(child: _ForgotPasswordButton(context)),
                sizedBoxH(20),

                Center(child: _HomeButton()),
                sizedBoxH(20),

                Center(child: _RegisterButton(context)),
                sizedBoxH(20),
                Text(message),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _TextFieldSifre() {
    return TextField(
      controller: _passwordController,
      decoration: customInputDecoration('Sifre'),
      cursorColor: AppColors.whitecolor,
      obscureText: true,
      style: TextStyle(color: AppColors.whitecolor),
    );
  }

  TextField _TextFieldEmail() {
    return TextField(
      controller: _emailController,
      decoration: customInputDecoration('Email'),
      cursorColor: AppColors.whitecolor,
      style: TextStyle(color: AppColors.whitecolor),
      keyboardType: TextInputType.emailAddress,
    );
  }

  TextButton _ForgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
        );
      },
      child: AppText.ForgotPasswordText,
    );
  }

  TextButton _RegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegisterScreen()),
        );
      },
      child: AppText.RegisterLinkText,
    );
  }

  TextButton _HomeButton() {
    return TextButton(
      onPressed: _login,
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: AppColors.green,
        ),
        child: Center(child: AppText.LoginText),
      ),
    );
  }

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.whitecolor),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.whitecolor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.whitecolor),
      ),
    );
  }
}
