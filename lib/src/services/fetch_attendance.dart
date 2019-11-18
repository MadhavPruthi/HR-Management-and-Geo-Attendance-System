import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geo_attendance_system/src/models/AttendaceList.dart';

String getFormattedDate(DateTime day) {
  String formattedDate = day.day.toString() +
      "-" +
      day.month.toString() +
      "-" +
      day.year.toString();
  return formattedDate;
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

  static Future<AttendanceList> getAttendanceListOfParticularDateBasedOnUID(
      String uid, DateTime dateTime) async {
    var snapshot = await getAttendanceOfParticularDateBasedOnUID(uid, dateTime);
    AttendanceList attendanceList =
        AttendanceList.fromJson(snapshot, getFormattedDate(dateTime));
    attendanceList.dateTime = dateTime;

    return attendanceList != null ? attendanceList : [];
  }

//  Future<List<Office>> getOfficeList() async {
//    DataSnapshot dataSnapshot = await _databaseReference.once();
//    Completer<List<Office>> completer;
//    final officeList = dataSnapshot.value["location"];
//    List<Office> result = [];
//
//    var officeMap = officeList;
//    officeMap.forEach((key, map) {
//      result.add(Office.fromJson(key, map.cast<String, dynamic>()));
//    });
//
//    return result;
//  }
}
