import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/screens/home_screen.dart';
import 'package:to_do_uygulamsi/screens/register_screen.dart';
import 'package:to_do_uygulamsi/service/auth_service.dart';

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
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        message = 'Giriş başarısız!';
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
                  "To - Do ",
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
                ],
              ),
              SizedBox(height: 30),
              TextField(
                controller: _passwordController,
                decoration: customInputDecoration('Sifre'),
                obscureText: true,
              ),
              SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'sifremi Unuttum',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: _login,
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text(
                        'Giris Yap',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: Text(
                    'Hesap Olustur',
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
