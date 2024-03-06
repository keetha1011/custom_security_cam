import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_security_cam/components/reusable.dart';

class AlertsList extends StatefulWidget {
  const AlertsList({super.key});

  @override
  State<AlertsList> createState() => _AlertsListState();
}

class _AlertsListState extends State<AlertsList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          PageHeaderText(pageHeader: "Alerts", pageSubHeader: "Works like an event log",),

          AlertsListBuilder(),

          SizedBox(width: 123,height: 123,child: Container(color: Colors.red,),),

        ],
      ),
    );
  }
}
