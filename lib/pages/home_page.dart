import 'package:custom_security_cam/pages/captures_view.dart';
import 'package:custom_security_cam/pages/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'alerts_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {


    int _SelectedIndex = 0;
    List<Widget> _widgetOptions = <Widget> [
      CapturesGallery(),
      AlertsList(),
      Preferences(),
    ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_SelectedIndex),
          ),
          bottomNavigationBar: Container(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: GNav(
                backgroundColor: Colors.black,
                color: Colors.white54,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.white12,
                padding: EdgeInsets.all(16),
                gap: 8,

                tabs: [
                  GButton(
                    icon: Icons.photo,
                    text: "Captures",
                  ),
                  GButton(
                    icon: Icons.notifications,
                    text: "Alerts",
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: "Settings",
                  ),
                ],
                selectedIndex: _SelectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _SelectedIndex = index;
                  });
                },
              ),
            ),
          ),
      ),
    );
  }
}
