import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  TextField(decoration: customInputDecoration('Kullanıcı Adı')),
                  SizedBox(height: 20),
                  TextField(decoration: customInputDecoration('Email')),
                  SizedBox(height: 20),
                  TextField(decoration: customInputDecoration('Sifre')),
                  SizedBox(height: 20),
                  TextField(decoration: customInputDecoration('Sifre Onay')),
                ],
              ),
              SizedBox(height: 30),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Container(
                    height: 50,
                    width: 150,
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey,
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
