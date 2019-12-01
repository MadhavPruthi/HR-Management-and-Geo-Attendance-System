import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/attendance_recorder.dart';
import '../pages/attendance_summary.dart';
import '../pages/leave_application.dart';
import '../pages/leave_status.dart';

void attendanceSummaryCallback(BuildContext context, FirebaseUser user) {
  Navigator.push(
    context,
    CupertinoPageRoute(
        builder: (context) => AttendanceSummary(
              title: "Attendance Summary",
              user: user,
            )),
  );
}

void attendanceRecorderCallback(BuildContext context, FirebaseUser user) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => AttendanceRecorderWidget(user: user)));
}

void leaveApplicationCallback(BuildContext context, FirebaseUser user) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LeaveApplicationWidget(
                title: "Leave Application",
                user: user,
              )));
}

void leaveStatusCallback(BuildContext context, FirebaseUser user) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LeaveStatusWidget(
                title: "Leave Status",
                user: user,
              )));
}

List<List> infoAboutTiles = [
  [
    "assets/icons/icons8-location-64.png",
    "Attendance Recorder",
    "Mark your In and Out Time",
    attendanceRecorderCallback
  ],
  [
    "assets/icons/icons8-leave-64.png",
    "Attendance Summary",
    "Check your previous record",
    attendanceSummaryCallback
  ],
  [
    "assets/icons/icons8-attendance-48.png",
    "Leaves Application",
    "Management",
    leaveApplicationCallback
  ],
  [
    "assets/icons/icons8-process-100.png",
    "Leaves Status",
    "Check pending status of leaves",
    leaveStatusCallback
  ],
];
