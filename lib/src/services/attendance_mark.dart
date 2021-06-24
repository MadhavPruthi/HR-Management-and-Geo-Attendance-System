import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/models/office.dart';
import 'package:geo_attendance_system/src/ui/widgets/Info_dialog_box.dart';
import 'package:location/location.dart';

import 'current_date.dart';
import 'fetch_attendance.dart';
import 'geofence.dart';

String findLatestIn(listOfAttendanceIterable) {
  List finalList = listOfAttendanceIterable
      .where((attendance) => attendance.toString().substring(0, 2) == "in")
      .toList();

  if (finalList.length == 0) return "";

  finalList.sort((a, b) {
    String time1 = a.toString().split("-")[1];
    String time2 = b.toString().split("-")[1];
    return time1.compareTo(time2);
  });

  return finalList.last.toString().split("-")[1];
}

String findLatestOut(listOfAttendanceIterable) {
  List finalList = listOfAttendanceIterable
      .where((attendance) => attendance.toString().substring(0, 3) == "out")
      .toList();

  if (finalList.length == 0) return "";

  finalList.sort((a, b) {
    String time1 = a.toString().split("-")[1];
    String time2 = b.toString().split("-")[1];
    return time1.compareTo(time2);
  });

  return finalList.last.toString().split("-")[1];
}

String findFirstIn(listOfAttendanceIterable) {
  List finalList = listOfAttendanceIterable
      .where((attendance) => attendance.toString().substring(0, 2) == "in")
      .toList();

  if (finalList.length == 0) return "";
  finalList.sort((a, b) {
    String time1 = a.toString().split("-")[1];
    String time2 = b.toString().split("-")[1];
    return time1.compareTo(time2);
  });

  return finalList.first.toString().split("-")[1];
}

String findFirstOut(listOfAttendanceIterable) {
  List finalList = listOfAttendanceIterable
      .where((attendance) => attendance.toString().substring(0, 3) == "out")
      .toList();

  if (finalList.length == 0) return "";

  finalList.sort((a, b) {
    String time1 = a.toString().split("-")[1];
    String time2 = b.toString().split("-")[1];
    return time1.compareTo(time2);
  });

  return finalList.first.toString().split("-")[1];
}

bool checkSuccessiveIn(listOfAttendanceIterable) {
  if (listOfAttendanceIterable.length > 0) {
    String lastOut = findLatestOut(listOfAttendanceIterable);
    String lastIn = findLatestIn(listOfAttendanceIterable);

    if (lastIn == "" || (lastOut != "" && lastIn.compareTo(lastOut) <= 0))
      return true;
    else
      return false;
  }
  return true;
}

bool checkSuccessiveOut(listOfAttendanceIterable) {
  if (listOfAttendanceIterable.length > 0) {
    String lastOut = findLatestOut(listOfAttendanceIterable);
    String lastIn = findLatestIn(listOfAttendanceIterable);

    if (lastOut == "" || (lastIn != "" && lastOut.compareTo(lastIn) <= 0))
      return true;
    else
      return false;
  }
  return true;
}

void markInAttendance(BuildContext context, Office office,
    LocationData currentPosition, User user) async {
  Future.delayed(Duration(seconds: 1), () {
    DateTime dateToday = getTodayDate();
    AttendanceDatabase.getAttendanceOfParticularDateBasedOnUID(
            user.uid, dateToday)
        .then((snapshot) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      bool isFeasible = true;
      String errorMessage = "";
      if (snapshot != null) {
        var listOfAttendanceIterable = snapshot.keys;
        if (listOfAttendanceIterable.length > 0 &&
            !checkSuccessiveIn(listOfAttendanceIterable)) {
          isFeasible = false;
          errorMessage = "Not Allowed to Mark In Successively";
        }
      }

      if (isFeasible &&
          (GeoFenceClass.geofenceState == "GeofenceEvent.dwell" ||
              GeoFenceClass.geofenceState == "GeofenceEvent.enter")) {
        AttendanceDatabase.markAttendance(user.uid, dateToday, office, "in")
            .then((_) {
          showDialogTemplate(
              context,
              "Attendance Info",
              "Marked \nStatus: ${GeoFenceClass.geofenceState}",
              "assets/gif/tick.gif",
              Color.fromRGBO(51, 205, 187, 1.0),
              "Great");
        });
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
    LocationData currentPosition, User user) async {
  Future.delayed(Duration(seconds: 1), () {
    DateTime dateToday = getTodayDate();
    AttendanceDatabase.getAttendanceOfParticularDateBasedOnUID(
            user.uid, dateToday)
        .then((snapshot) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      bool isFeasible = true;
      String errorMessage = "";

      if (snapshot != null) {
        var listOfAttendanceIterable = snapshot.keys;
        if (listOfAttendanceIterable.length > 0 &&
            !checkSuccessiveOut(listOfAttendanceIterable)) {
          isFeasible = false;
          errorMessage = "Not Allowed to Mark Out Successively";
        } else if (listOfAttendanceIterable.length == 0) {
          isFeasible = false;
          errorMessage = "No IN-Entry Found!";
        }
      } else {
        isFeasible = false;
        errorMessage = "No IN-Entry Found!";
      }

      if (isFeasible &&
          (GeoFenceClass.geofenceState == "GeofenceEvent.dwell" ||
              GeoFenceClass.geofenceState == "GeofenceEvent.enter")) {
        AttendanceDatabase.markAttendance(user.uid, dateToday, office, "out")
            .then((_) {
          showDialogTemplate(
              context,
              "Attendance Info",
              "Marked \nStatus: ${GeoFenceClass.geofenceState}",
              "assets/gif/tick.gif",
              Color.fromRGBO(51, 205, 187, 1.0),
              "Great");
        });
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
