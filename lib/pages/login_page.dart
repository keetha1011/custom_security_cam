import 'package:custom_security_cam/components/logintextfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(210, 210, 210, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),

              //logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              const Text(
                "Welcome back you've been missed!",
                style:TextStyle(
                  color: Color.fromRGBO(100, 100, 100, 1),
                  fontSize:16,
                ),
              ),

              const SizedBox(height: 50),

              LoginTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              SizedBox(height: 10),

              LoginTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
