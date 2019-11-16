import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/models/office.dart';
import 'package:location/location.dart';

import 'geofence.dart';

void showDialogTemplate(BuildContext context, String title, String subtitle) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(subtitle),
        actions: <Widget>[
          FlatButton(
            child: Text('Great!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void markInAttendance(
    BuildContext context, Office office, LocationData currentPosition) {
  if (GeoFenceClass.geofenceState == "GeofenceEvent.dwell" ||
      GeoFenceClass.geofenceState == "GeofenceEvent.enter") {
    showDialogTemplate(
        context, "Attendance Info", "Marked ${GeoFenceClass.geofenceState}");
  }
}
