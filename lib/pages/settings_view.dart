import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cam_review/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';


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
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final profilePhotoRef = FirebaseStorage.instance
            .ref()
            .child('${user.uid}/profpic/0.jpg');

        try {
          await profilePhotoRef.putFile(File(pickedFile.path));
          final profilePhotoUrl = await profilePhotoRef.getDownloadURL();
          setState(() {
            this.profilePhotoUrl = profilePhotoUrl;
          });
        } catch (e) {
          if (kDebugMode) {
            print('Error uploading profile photo: $e');
          }
        }
      }
    }
  }

  Future<void> fetchProfilePhotoUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profilePhotoRef = FirebaseStorage.instance
          .ref()
          .child('${user.uid}/profpic/0.jpg');

      try {
        final profilePhotoUrl = await profilePhotoRef.getDownloadURL();
        setState(() {
          this.profilePhotoUrl = profilePhotoUrl;
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching profile photo URL: $e');
        }
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

  Future<void> setDisplayName(final userName) async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({"name": userName});
    }
  }

  Future<void> updateDisplayName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final newDisplayName = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          final nameController = TextEditingController(text: displayName);
          return AlertDialog(
            title: const Text('Update Display Name'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter your new display name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setDisplayName(nameController);
                  Navigator.pop(context, nameController.text.trim());
                  fetchDisplayName();
                  },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );

      if (newDisplayName != null && newDisplayName.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'name': newDisplayName});
        setState(() {
          displayName = newDisplayName;
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
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text('Take Photo'),
                                        onTap: () {
                                          pickImage(ImageSource.camera);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.image),
                                        title: const Text('Choose from Gallery'),
                                        onTap: () {
                                          pickImage(ImageSource.gallery);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            child: profilePhotoUrl != null
                                ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: profilePhotoUrl!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            )
                                : const Icon(Icons.edit),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            GestureDetector(
                              onTap: updateDisplayName,
                              child: Text(
                                displayName ?? 'Set your name',
                                style: const TextStyle(
                                  fontSize: 16,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              user?.email ?? '',
                              style: const TextStyle(
                                fontSize: 14,

                              ),
                            ),
                            const SizedBox(height: 4),

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
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    children : [
                      const Center(
                          child: SizedBox(
                            width: 50,
                            height: 30,
                          ),
                      ),
                      Text("This app was made by Guna, Kshauneesh, Keerthan, Tanvi", style: TextStyle(fontFamily: GoogleFonts.dmSans().fontFamily),),
                      Text("as a part of Home Automation Internship of the first year.\nUnder the guidance of Ms. Sneha Shetty",style: TextStyle(fontFamily: GoogleFonts.dmSans().fontFamily),),

                      const SizedBox(height: 12,),
                      Text("N.M.A.M.I.T",style: TextStyle(fontFamily: GoogleFonts.dmSans().fontFamily),textAlign: TextAlign.right,),
                    ],
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
