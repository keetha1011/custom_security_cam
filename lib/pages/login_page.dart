import 'package:custom_security_cam/components/logintextfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(108, 103, 156, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),

              //logo
              const Icon(
                Icons.lock,
                size: 100,
                //shadows: [Shadow(
                //    color: Color.fromARGB(1, 200, 200, 200),
                //    blurRadius: 0,
                //    offset: Offset(25, 25)
                //),],
              ),

              const SizedBox(height: 50),

              const Text(
                "Welcome back you've been missed!\nWell let's get you logged in",
                style:TextStyle(
                  color: Colors.black54,
                  fontSize:16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
