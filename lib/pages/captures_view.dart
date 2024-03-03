import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:custom_security_cam/components/reusable.dart';

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
          Container(
              child: PageHeaderText(pageHeader: "Gallery", pageSubHeader: "Recent Captures by the Camera",)
          ),
          const SizedBox(width: 25,height: 25,),
          DownloadAndDisplayImages(userEmail: "nnm23am025@nmamit.in"),
        ],
      ),
    );
  }
}