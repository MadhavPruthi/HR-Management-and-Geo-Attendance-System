import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geo_attendance_system/src/models/AttendaceList.dart';
import 'package:geo_attendance_system/src/models/office.dart';

String getFormattedDate(DateTime day) {
  String formattedDate = day.day.toString() +
      "-" +
      day.month.toString() +
      "-" +
      day.year.toString();
  return formattedDate;
}

String getFormattedTime(DateTime day) {
  String time = day.hour.toString() +
      ":" +
      day.minute.toString() +
      ":" +
      day.second.toString();

  return time;
}

class AttendanceDatabase {
  static final _databaseReference = FirebaseDatabase.instance.reference();
  static final AttendanceDatabase _instance = AttendanceDatabase._internal();

  factory AttendanceDatabase() {
    return _instance;
  }

  AttendanceDatabase._internal();

  static Future<DataSnapshot> getAttendanceBasedOnUID(String uid) async {
    DataSnapshot dataSnapshot =
        await _databaseReference.child("Attendance").child(uid).once();
    return dataSnapshot;
  }

  static Future<dynamic> getAttendanceOfParticularDateBasedOnUID(
      String uid, DateTime dateTime) async {
    DataSnapshot snapshot = await getAttendanceBasedOnUID(uid);
    String formattedDate = getFormattedDate(dateTime);
    return snapshot.value[formattedDate];
  }

  static Future<Map<String, String>> getOfficeFromID() async {
    DataSnapshot dataSnapshot =
        await _databaseReference.child("location").once();
    Map<String, String> map = new Map();

    dataSnapshot.value.forEach((key, value) {
      map[key] = value["name"];
    });
    return map;
  }

  static Future<AttendanceList> getAttendanceListOfParticularDateBasedOnUID(
      String uid, DateTime dateTime) async {
    var snapshot = await getAttendanceOfParticularDateBasedOnUID(uid, dateTime);
    var mapOfOffice = await getOfficeFromID();
    AttendanceList attendanceList =
        AttendanceList.fromJson(snapshot, getFormattedDate(dateTime), mapOfOffice);
    attendanceList.dateTime = dateTime;

    return attendanceList != null ? attendanceList : [];
  }

  static Future markAttendance(
      String uid, DateTime dateTime, Office office, String markType) async {
    String time = getFormattedTime(dateTime);
    String date = getFormattedDate(dateTime);
    var json = {
      "office": office.getKey,
      "time": time,
    };
    String markChild = markType + "-" + time;
    return _databaseReference
        .reference()
        .child("Attendance")
        .child(uid)
        .child(date)
        .child(markChild)
        .update(json);
  }
}
