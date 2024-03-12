import 'package:custom_security_cam/pages/captures_view.dart';
import 'package:custom_security_cam/pages/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {


    int selectedIndex = 0;
    final List<Widget> _widgetOptions = <Widget> [
      const CapturesGallery(),
      const Preferences(),
    ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(selectedIndex),
          ),
          bottomNavigationBar: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: GNav(
                backgroundColor: Colors.black,
                color: Colors.white54,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.white12,
                padding: const EdgeInsets.symmetric(horizontal: 54, vertical: 16),
                gap: 8,

                tabs: const [
                  GButton(
                    icon: Icons.photo,
                    text: "Captures",
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: "Settings",
                  ),
                ],
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
          ),
      ),
    );
  }
}
