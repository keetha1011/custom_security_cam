import 'package:CamReview/components/reusable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'signup_page.dart';
import "package:fluttertoast/fluttertoast.dart";

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
  try {
    final email = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email and Password are required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    //final user = FirebaseAuth.instance.currentUser;
    final userRef = FirebaseFirestore.instance
        .collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

    userRef.get().then( (document) {
      if (document.exists) {
        print(document);
      } else {
        userRef.set({ 'name': "Set your name" });
        print("executed this code");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Error getting document: $error");
      }
    });

    if (userCredential.user?.emailVerified == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Please verify your email \nbefore logging in. Check your inbox",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }


  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else if (e.code == 'wrong-password') {
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  } catch (e) {
    Fluttertoast.showToast(
        msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  }

  Future<void> _resetpassword(BuildContext context) async {
    try {
      final email = usernameController.text.trim();

      // Validate input
      if (email.isEmpty) {
        Fluttertoast.showToast(
            msg: "Email is required",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }

      // Perform reset
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      Fluttertoast.showToast(
          msg: "Password reset email has been sent",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("$e");
      }
    }
  }

  Future<void> _signup(BuildContext context) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupPage()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [

          const PageHeaderText(pageHeader: "CamReview", pageSubHeader: "Let's get you logged in",),
          const SizedBox(height: 200,),
          Center(
            child: Column(
              children: [

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

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _signup(context);
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), shadowColor: MaterialStateProperty.all(Colors.white), elevation: MaterialStateProperty.all(1)),
                        child: const Text(
                          "New User?",
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ),

                      ElevatedButton(
                          onPressed: () {
                            _resetpassword(context);
                            },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), shadowColor: MaterialStateProperty.all(Colors.white), elevation: MaterialStateProperty.all(1)),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: 200,
                  height: 50,
                  child:
                    ElevatedButton(
                      onPressed: () {
                        _login(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      child: const Text('Login'),
                    ),

                ),
              ],
            ),
        ),
      ],),
    );
  }
}