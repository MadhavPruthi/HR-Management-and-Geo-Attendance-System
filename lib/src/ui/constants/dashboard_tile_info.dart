import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/attendance_recorder.dart';
import '../pages/attendance_summary.dart';

void attendanceSummaryCallback(BuildContext context, FirebaseUser user) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => AttendanceSummary(
              title: "Calendar",
              user: user,
            )),
  );
}

void attendanceRecorderCallback(BuildContext context, FirebaseUser user) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AttendanceRecorderWidget(user: user)));
}

List<List> infoAboutTiles = [
  [
    Icons.pin_drop,
    "Attendance Recorder",
    "Mark your In and Out Time",
    attendanceRecorderCallback
  ],
  [
    Icons.subject,
    "Attendance Summary",
    "Check your previous record",
    attendanceSummaryCallback
  ],
  [Icons.time_to_leave, "Leaves Application/Withdrawal", "Management", null],
  [Icons.timeline, "Leaves Status", "Check pending status of leaves", null],
];
