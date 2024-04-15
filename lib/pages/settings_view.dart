import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_security_cam/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/reusable.dart';

class Preferences extends StatefulWidget {
  const Preferences({super.key});

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {

  String? profilePhotoUrl;
  String? displayName;
  bool val1Checked = false;

  Future<void> fetchProfilePhotoUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profilePhotoRef = FirebaseStorage.instance
          .ref()
          .child('${user.uid}/nigs/0.jpg');

      try {
        final profilePhotoUrl = await profilePhotoRef.getDownloadURL();
        setState(() {
          this.profilePhotoUrl = profilePhotoUrl;
        });
      } catch (e) {
        print('Error fetching profile photo URL: $e');
      }
    }
  }

  Future<void> fetchDisplayName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          displayName = userDoc.data()?['name'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfilePhotoUrl();
    fetchDisplayName();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: ListView(
        children: [
          const PageHeaderText(
            pageHeader: "Settings",
            pageSubHeader: "Configure your camera settings or\nmodify your account",
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        child: profilePhotoUrl != null
                            ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profilePhotoUrl!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Icon(Icons.person),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16,),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), foregroundColor: MaterialStateProperty.all(Colors.red)),
                        child: const Text(
                          "Log out",
                          style: TextStyle(
                            color: Colors.red,
                            shadows: [Shadow(
                              offset: Offset(0, 0),
                              blurRadius: 48,
                              color: Colors.red,
                            )]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Column(

                      children : [
                        Center(child: SizedBox(width: 50,height: 30,)),
                        Text("This app was made by Guna, Kshauneesh, Keerthan, Tanvi", style: TextStyle(fontFamily: GoogleFonts.dmSans().fontFamily),),
                        Text("as a part of Home Automation Internship of the first year.\nUnder the guidance of Ms. Sneha Shetty",style: TextStyle(fontFamily: GoogleFonts.dmSans().fontFamily),),

                        const SizedBox(height: 12,),
                        Text("N.M.A.M.I.T",style: TextStyle(fontFamily: GoogleFonts.dmSans().fontFamily),textAlign: TextAlign.right,),
                      ],
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
