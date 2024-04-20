import 'package:custom_security_cam/components/reusable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
  try {
    final email = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Validate input
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    // Perform login
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Navigate to home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      if (kDebugMode) {
        print('No user found for that email.');
      }
    } else if (e.code == 'wrong-password') {
      if (kDebugMode) {
        print('Wrong password provided for that user.');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error during login: $e');
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              
              const Icon(
                Icons.lock,
                size: 100,
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

              const SizedBox(height: 10),

              LoginTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  _login(context);
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black), foregroundColor: MaterialStateProperty.all(Colors.white),),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ],),
    );
  }
}