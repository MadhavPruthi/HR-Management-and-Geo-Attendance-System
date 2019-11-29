import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_attendance_system/src/models/office.dart';
import 'package:geo_attendance_system/src/services/fetch_offices.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
import 'package:geo_attendance_system/src/ui/constants/strings.dart';
import 'package:geo_attendance_system/src/ui/pages/dashboard.dart';
import 'package:geofencing/geofencing.dart';
import 'package:permission_handler/permission_handler.dart';

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
  var geoFenceActive = false;
  var result;
  String error;
  Office allottedOffice;
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<void> _initializeGeoFence() async {
    try {
      result = await _permissionHandler
          .requestPermissions([PermissionGroup.location]);
      switch (result[PermissionGroup.location]) {
        case PermissionStatus.granted:
          GeofencingManager.initialize().then((_) {
            officeDatabase.getOfficeBasedOnUID(widget.user.uid).then((office) {
              GeoFenceClass.startListening(
                  office.latitude, office.longitude, office.radius);
              setState(() {
                geoFenceActive = true;
                allottedOffice = office;
              });
            });
          });
          break;
        case PermissionStatus.denied:
          print("DENIED");
          break;
        case PermissionStatus.disabled:
          // do something
          break;
        case PermissionStatus.restricted:
          // do something
          break;
        case PermissionStatus.unknown:
          // do something
          break;
        default:
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _initializeGeoFence();

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
            padding: const EdgeInsets.only(left: 55.0),
            child: new Text(
              "DASHBOARD",
              style: TextStyle(
                  fontSize: 25.0,
                  fontFamily: "Poppins-Medium",
                  fontWeight: FontWeight.w200),
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
        body: geoFenceActive == false
            ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      splashScreenColorBottom,
                      splashScreenColorTop
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topRight,
                  ),
                ),
                child: Column(children: <Widget>[
                  LinearProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        splashScreenColorBottom),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      "Please Wait..\nwhile we are setting up things",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  )
                ]))
            : new Dashboard(
                controller: controller,
                user: widget.user,
              ));
  }
}
