import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:CamReview/components/reusable.dart';

class CapturesGallery extends StatefulWidget {
  const CapturesGallery({super.key});

  @override
  State<CapturesGallery> createState() => _CapturesGalleryState();
}

class _CapturesGalleryState extends State<CapturesGallery> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const PageHeaderText(pageHeader: "Gallery", pageSubHeader: "Recent Captures by the Camera",),
          const SizedBox(width: 25,height: 25,),
          DownloadAndDisplayImages(userUID: FirebaseAuth.instance.currentUser!.uid,),
        ],
      ),
    );

  }
}