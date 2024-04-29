import 'package:cam_review/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/reusable.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _signup(BuildContext context) async{
    try{
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

      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await userCredential.user?.sendEmailVerification();



      Fluttertoast.showToast(
        msg: "Verification email sent. Please check your inbox.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
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

  Future<void> _login(BuildContext context) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const PageHeaderText(pageHeader: "CamReview", pageSubHeader: "Create a new account",),
          const SizedBox(height: 200,),

          Center(
            child: Column(
              children: [
                LoginTextField(
                  controller: usernameController,
                  hintText: 'E-mail id',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                LoginTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _login(context);
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), shadowColor: MaterialStateProperty.all(Colors.white), elevation: MaterialStateProperty.all(1)),
                        child: const Text(
                          "Already have an account. Login?",
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),



                    ],
                  ),
                ),

                const SizedBox(height: 20,),

                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _signup(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: const Text('Sign Up'),
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
