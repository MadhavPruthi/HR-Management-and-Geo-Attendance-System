import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/models/office.dart';
import 'package:geo_attendance_system/src/ui/widgets/loader_dialog.dart';
import 'package:location/location.dart';

import 'fetch_attendance.dart';
import 'geofence.dart';

void showDialogTemplate(BuildContext context, String title, String subtitle,
    String gif, Color color, String buttonText) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 40,
        child: AlertDialog(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                gif,
                width: 175,
              ),
              Text(subtitle, style: TextStyle(color: Colors.white60)),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

void markInAttendance(BuildContext context, Office office,
    LocationData currentPosition, FirebaseUser user) async {
  onLoadingDialog(context);
  Future.delayed(Duration(seconds: 3), () {
    Navigator.pop(context);
    DateTime dateToday =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    AttendanceDatabase.getAttendanceOfParticularDateBasedOnUID(
            user.uid, dateToday)
        .then((snapshot) {
      var listOfAttendanceIterable = snapshot.keys;
      bool isFeasible = true;
      String errorMessage = "";
      if (listOfAttendanceIterable.length > 0 &&
          listOfAttendanceIterable.last.toString() == "in") {
        isFeasible = false;
        errorMessage = "Not Allowed to Mark In Successively";
      }

      if (isFeasible &&
          (GeoFenceClass.geofenceState == "GeofenceEvent.dwell" ||
              GeoFenceClass.geofenceState == "GeofenceEvent.enter")) {
        showDialogTemplate(
            context,
            "Attendance Info",
            "Marked \nStatus: ${GeoFenceClass.geofenceState}",
            "assets/gif/tick.gif",
            Color.fromRGBO(51, 205, 187, 1.0),
            "Great");
      } else {
        if (isFeasible) errorMessage = "Out of the allotted Location!";
        showDialogTemplate(
            context,
            "Attendance Info",
            "$errorMessage\nStatus: ${GeoFenceClass.geofenceState}",
            "assets/gif/close.gif",
            Color.fromRGBO(200, 71, 108, 1.0),
            "Oops!");
      }
    });
  });
}

void markOutAttendance(BuildContext context, Office office,
    LocationData currentPosition, FirebaseUser user) async {
  DateTime dateToday =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  AttendanceDatabase.getAttendanceOfParticularDateBasedOnUID(
          user.uid, dateToday)
      .then((snapshot) {
    var listOfAttendanceIterable = snapshot.keys;
    bool isFeasible = true;
    String errorMessage = "";
    if (listOfAttendanceIterable.length > 0 &&
        listOfAttendanceIterable.last.toString() == "out") {
      isFeasible = false;
      errorMessage = "Not Allowed to Mark Out Successively";
    }

    if (isFeasible &&
        (GeoFenceClass.geofenceState == "GeofenceEvent.dwell" ||
            GeoFenceClass.geofenceState == "GeofenceEvent.enter")) {
      showDialogTemplate(
          context,
          "Attendance Info",
          "Marked \nStatus: ${GeoFenceClass.geofenceState}",
          "assets/gif/tick.gif",
          Color.fromRGBO(51, 205, 187, 1.0),
          "Great");
    } else {
      if (isFeasible) errorMessage = "Out of the allotted Location!";
      showDialogTemplate(
          context,
          "Attendance Info",
          "$errorMessage\nStatus: ${GeoFenceClass.geofenceState}",
          "assets/gif/close.gif",
          Color.fromRGBO(200, 71, 108, 1.0),
          "Oops!");
    }
  });
}
