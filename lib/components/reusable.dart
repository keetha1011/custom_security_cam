import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      padding: EdgeInsets.only(right: 15, top: 25),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: pageHeader,
                style: TextStyle(color: Colors.black87, fontSize: 44, fontFamily: GoogleFonts.dmSans().fontFamily)
            ),
            TextSpan(
                text: "\n" + pageSubHeader,
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
  final String userEmail; // Pass user email securely

  const DownloadAndDisplayImages({Key? key, required this.userEmail})
      : super(key: key);

  @override
  _DownloadAndDisplayImagesState createState() =>
      _DownloadAndDisplayImagesState();
}

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Use opaque background for better image viewing
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make app bar transparent
      ),
      body: Center(
        child: InteractiveViewer(
          child: Hero(
            tag: imageUrl, // Enable hero animation for transition (optional)
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain, // Adjust fit as needed
            ),
          ),
        ),
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
    fetchImages(widget.userEmail);
  }

  Future<void> fetchImages(String userEmail) async {
    try {
      final ListResult imagesRef = await storage
          .ref()
          .child('$userEmail/captures')
          .listAll(); // Get all images in the directory
      final List<Reference> imageRefs = imagesRef.items;

      List<Future<String?>> imageUrlFutures = imageRefs
          .map((imageRef) => imageRef.getDownloadURL())
          .toList(); // Get download URLs for each image

      List<String?> urls = await Future.wait(
          imageUrlFutures); // Fetch URLs concurrently

      setState(() {
        imageUrls = urls;
        isLoading = false; // Mark loading as done
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle exception gracefully (e.g., display error message)
      print("Error fetching images: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.black87,)) // Show loading indicator
        : GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      children: imageUrls.map((url) {
        return GestureDetector(
          onLongPress: () async {
            if (url != null) {
              // Show zoomed preview (replace with your implementation)
              // Example using a modal:
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImagePreviewScreen(imageUrl: url!),
                ),
              );
            }
          },
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15), // Add rounded corners
              child: url != null
                  ? Image.network(
                url,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                "assets/images/user.jpg", // Placeholder image
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}