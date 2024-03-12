import 'package:custom_security_cam/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/reusable.dart';

class Preferences extends StatefulWidget {
  const Preferences({super.key});

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  
  bool val1Checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const PageHeaderText(pageHeader: "Settings", pageSubHeader: "Configure your camera settings or\nmodify your account",)
          ,
          Center(
            child: Column(
              children: 
              [
                const SizedBox(width: 50, height: 50,),
                
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white60, 
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      const Text(
                        "VALUE1 TEXT",
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(width: 8.0,),
                      
                      Checkbox(
                        value: val1Checked, 
                        onChanged: (value) {
                          setState(() {
                            val1Checked = value!;
                          });
                        },
                      ),

                    ],
                  ),
                ),

                ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black), foregroundColor: MaterialStateProperty.all(Colors.white)),
                child: const Text(
                    "Log out",
                    style: TextStyle(color: Colors.white,
                ),
              ),
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
