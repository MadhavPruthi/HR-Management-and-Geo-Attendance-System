import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geo_attendance_system/src/models/office.dart';
import 'package:geo_attendance_system/src/services/fetch_offices.dart';
import 'package:geo_attendance_system/src/services/geofencing.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
import 'package:geo_attendance_system/src/ui/pages/dashboard.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  OfficeDatabase officeDatabase = new OfficeDatabase();
  final _databaseReference = FirebaseDatabase.instance.reference();
  var geoFenceActive = false;
  late PermissionStatus result;
  String? error;
  Office? allottedOffice;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  Future<void> _initializeGeoFence(BuildContext context) async {
    try {
      result = await Permission.location.request();
      switch (result) {
        case PermissionStatus.granted:
          officeDatabase.getOfficeBasedOnUID(widget.user.uid).then((office) {
            print(office.latitude);

            GeoFencing.of(context).service.startGeofencing(office);

            setState(() {
              geoFenceActive = true;
              allottedOffice = office;
            });
          });

          break;
        case PermissionStatus.denied:
          print("DENIED");
          break;
        case PermissionStatus.permanentlyDenied:
          // do something
          break;
        case PermissionStatus.restricted:
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

  void showDialogNotification(BuildContext context, String text) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: "poppins-medium",
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Okay',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        showDialogNotification(context, message.data["notification"]["body"]);
      },
    );

    firebaseMessaging.requestPermission();
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    firebaseMessaging.getToken().then((token) {
      _databaseReference.child("users").child(widget.user.uid).update({
        "notificationToken": token,
      });
    });
    Future.microtask(() => _initializeGeoFence(context));

    controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 300), value: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
