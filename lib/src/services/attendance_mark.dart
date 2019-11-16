import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/models/office.dart';
import 'package:location/location.dart';

import 'geofence.dart';

void markInAttendance(
    BuildContext context, Office office, LocationData currentPosition) {
  print(GeoFenceClass.geofenceState);
  if (GeoFenceClass.geofenceState == "GeofenceEvent.dwell" ||
      GeoFenceClass.geofenceState == "GeofenceEvent.enter") {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Text("Button Pressed");
      },
    );
  }
}
