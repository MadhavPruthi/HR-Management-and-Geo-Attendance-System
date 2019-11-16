import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/models/office.dart';
import 'package:location/location.dart';

import 'geofence.dart';

void showDialogTemplate(
    BuildContext context, String title, String subtitle, String gif) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 40,
        child: AlertDialog(
          backgroundColor: Color.fromRGBO(51, 205, 187, 1.0),
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
                'Great!',
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

void markInAttendance(
    BuildContext context, Office office, LocationData currentPosition) {
  if (GeoFenceClass.geofenceState == "GeofenceEvent.dwell" ||
      GeoFenceClass.geofenceState == "GeofenceEvent.enter") {
    showDialogTemplate(
        context,
        "Attendance Info",
        "Marked \nStatus: ${GeoFenceClass.geofenceState}",
        "assets/gif/tick.gif");
  } else {
    showDialogTemplate(
        context,
        "Attendance Info",
        "Not in the desired area!\nStatus: ${GeoFenceClass.geofenceState}",
        "assets/gif/tick.gif");
  }
}
