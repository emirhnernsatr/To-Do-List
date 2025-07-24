import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/screens/login_screen.dart';
import 'package:to_do_uygulamsi/service/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  String message = '';

  void _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final passwordConfrim = _passwordConfirmController.text.trim();

    if (password != passwordConfrim) {
      setState(() {
        message = 'Şifreler eşleşmiyor';
      });
      return;
    }

    final user = await _authService.registerWithEmailAndPassword(
      email,
      password,
    );
    setState(() {
      if (user != null) {
        message = 'Kayıt başarılı! Hoşgeldin: ${user.email}';
        Navigator.pop(context);
      } else {
        message = 'Kayıt başarısız!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                child: Text(
                  "Kayıt ol",
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 70),
              Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: customInputDecoration('Email'),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: customInputDecoration('Sifre'),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordConfirmController,
                    decoration: customInputDecoration('Sifre Onay'),
                  ),
                ],
              ),
              SizedBox(height: 30),

              Center(
                child: TextButton(
                  onPressed: _register,
                  child: Container(
                    height: 50,
                    width: 150,
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text(
                        'kayıt Ol',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    'Hesabın Var Mı ?',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }
}
