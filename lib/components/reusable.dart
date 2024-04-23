import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import '../pages/home_page.dart';


class PageHeaderText extends StatelessWidget {
  final String pageHeader;
  final String pageSubHeader;

  const PageHeaderText({
    super.key,
    required this.pageHeader,
    required this.pageSubHeader,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, top: 25),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: pageHeader,
                style: TextStyle(color: Colors.black87, fontSize: 44, fontFamily: GoogleFonts.dmSans().fontFamily)
            ),
            TextSpan(
                text: "\n$pageSubHeader",
                style: TextStyle(color: Colors.black87, fontSize: 18, fontFamily: GoogleFonts.dmSans().fontFamily)
            )
          ],
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(155, 155, 155, 0.1)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 1)),
          ),
          fillColor: const Color.fromRGBO(245, 245, 245, 0.5),
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}

Widget buildImage(String imageUrl) {
  return Image.network(imageUrl, width: 200, height: 200, fit: BoxFit.cover);
}


class DownloadAndDisplayImages extends StatefulWidget {
  final String userUID;

  const DownloadAndDisplayImages({super.key, required this.userUID});

  @override
  _DownloadAndDisplayImagesState createState() =>
      _DownloadAndDisplayImagesState();
}

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewScreen({super.key, required this.imageUrl});

  Future<void> downloadPhoto() async {
    try {
      const directory =  '/storage/emulated/0/Pictures/SecurityCAM';
      final filePath = '$directory/downloaded_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        final file = File(filePath);
        await file.writeAsBytes(imageBytes);
        if (kDebugMode) {
          print('Image downloaded to $filePath');
        }
      } else {
        if (kDebugMode) {
          print('Failed to download image. Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading image: $e');
      }
    }
  }

  Future<void> sendPhoto() async {
    try {
      http.Response response = await http.get(Uri.parse(imageUrl));
      await Share.shareXFiles(
        [XFile.fromData(response.bodyBytes, name: 'security_camera_captured${DateTime.now()}.jpg', mimeType: 'image/jpeg')],
        text: 'CapturedImage',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error sharing image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,

        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
                onPressed:() {
                  FirebaseStorage.instance.refFromURL(imageUrl).delete();
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                icon: const Icon(Icons.delete_forever),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
                onPressed: () {
                  sendPhoto();
                },
                icon: const Icon(Icons.send),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [

          Positioned.fill(
            child: Hero(
              tag: "blurred-$imageUrl",
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.multiply,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              minScale: 1.0,
              maxScale: 2.0,
              clipBehavior: Clip.none,
              child: Hero(
                tag: imageUrl,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _DownloadAndDisplayImagesState extends State<DownloadAndDisplayImages> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  Map<String, dynamic> imageCache = {};
  List<String?> imageUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImages(widget.userUID);
  }

  Future<void> fetchImages(String userUID) async {
    try {
      final ListResult imagesRef = await storage
          .ref()
          .child('$userUID/')
          .listAll();
      final List<Reference> imageRefs = imagesRef.items;

      List<Future<String?>> imageUrlFutures = imageRefs
          .map((imageRef) => imageRef.getDownloadURL())
          .toList();

      List<String?> urls = await Future.wait(
          imageUrlFutures);
      setState(() {
        imageUrls = urls;
        imageUrls = imageUrls.reversed.toList();
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print("Error fetching images: $e");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.black87,))
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: imageUrls.map((url) {
          return GestureDetector(
            onTap: () async {
              if (url != null) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImagePreviewScreen(imageUrl: url),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: url != null
                      ? CachedNetworkImage(
                    imageUrl: url,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    "assets/images/user.jpg",
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ),
          );
                }).toList(),
              ),
        );
  }
}


