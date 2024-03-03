import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_security_cam/components/reusable.dart';

class AlertsList extends StatefulWidget {
  const AlertsList({super.key});

  @override
  State<AlertsList> createState() => _AlertsListState();
}

class _AlertsListState extends State<AlertsList> {
  // State variables and methods for image loading/display (implementation details omitted)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Integrate your existing Google navigation bar implementation here

      body: ListView(
        children: [
          Container(
              child: PageHeaderText(pageHeader: "Alerts", pageSubHeader: "Works like an event log",)
          ),

        ],
      ),
    );
  }
}
