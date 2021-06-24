import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/attendance_recorder.dart';
import '../pages/attendance_summary.dart';
import '../pages/leave_application.dart';
import '../pages/leave_status.dart';

void attendanceSummaryCallback(BuildContext context, User user) {
  Navigator.push(
    context,
    CupertinoPageRoute(
        builder: (context) => AttendanceSummary(
              title: "Attendance Summary",
              user: user,
            )),
  );
}

void attendanceRecorderCallback(BuildContext context, User user) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => AttendanceRecorderWidget(user: user)));
}

void leaveApplicationCallback(BuildContext context, User user) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => LeaveApplicationWidget(
                title: "Leave Application",
                user: user,
              )));
}

void leaveStatusCallback(BuildContext context, User user) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => LeaveStatusWidget(
                title: "Leave Status",
                user: user,
              )));
}

List<List> infoAboutTiles = [
  [
    "assets/icons/attendance_recorder.png",
    "Attendance Recorder",
    "Mark your In and Out Time",
    attendanceRecorderCallback
  ],
  [
    "assets/icons/attendance_summary.png",
    "Attendance Summary",
    "Check your previous record",
    attendanceSummaryCallback
  ],
  [
    "assets/icons/leave_application.png",
    "Leaves Application",
    "Management",
    leaveApplicationCallback
  ],
  [
    "assets/icons/leave_status.png",
    "Leaves Status",
    "Check pending status of leaves",
    leaveStatusCallback
  ],
];
