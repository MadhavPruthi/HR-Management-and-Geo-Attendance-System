import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/services/fetch_offices.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
import 'package:geo_attendance_system/src/ui/constants/strings.dart';
import 'package:geo_attendance_system/src/ui/pages/dashboard.dart';
import 'package:geofencing/geofencing.dart';

import '../../services/geofence.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;

  HomePage({this.user});

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  OfficeDatabase officeDatabase = new OfficeDatabase();

  @override
  void initState() {
    super.initState();
    GeofencingManager.initialize().then((_) {
      officeDatabase.getOfficeBasedOnUID(widget.user.uid).then((office) {
        GeoFenceClass.startListening(office.latitude, office.longitude);
      });
    });

    controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 300), value: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    GeofencingManager.removeGeofenceById(fence_id);
  }

  bool get isPanelVisible {
    final AnimationStatus status = controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 65.0),
          child: new Text(
            "Dashboard",
            style: TextStyle(fontSize: 25.0),
          ),
        ),
        elevation: 0.0,
        backgroundColor: dashBoardColor,
        leading: new IconButton(
          onPressed: () {
            double velocity = 2.0;
            controller.fling(velocity: isPanelVisible ? -velocity : velocity);
          },
          icon: new AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: controller.view,
          ),
        ),
      ),
      body: new Dashboard(
        controller: controller,
        user: widget.user,
      ),
    );
  }
}
