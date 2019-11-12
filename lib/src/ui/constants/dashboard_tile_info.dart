import 'package:flutter/material.dart';

import '../pages/attendance_recorder.dart';
import '../pages/calendar.dart';

void attendanceSummaryCallback(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => MyHomePage(
              title: "Calendar",
            )),
  );
}

void attendanceRecorderCallback(BuildContext context) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => AttendanceRecorderWidget()));
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
