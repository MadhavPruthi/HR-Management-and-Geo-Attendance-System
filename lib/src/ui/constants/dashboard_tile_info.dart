import 'package:flutter/material.dart';

import '../pages/calendar.dart';


void funcToPass(BuildContext context){

  print("PUSHED");
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MyHomePage()),
  );

}
List<List> infoAboutTiles = [
  [Icons.pin_drop, "Attendance Recorder", "Mark your In and Out Time", null],
  [
    Icons.subject,
    "Attendance Summary",
    "Check your previous record",
    funcToPass
  ],
  [Icons.time_to_leave, "Leaves Application/Withdrawal", "Management", null],
  [Icons.timeline, "Leaves Status", "Check pending status of leaves", null],
];
