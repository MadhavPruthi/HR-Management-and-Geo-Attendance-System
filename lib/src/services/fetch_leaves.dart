import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geo_attendance_system/src/models/leave.dart';

class LeaveDatabase {
  final _databaseReference = FirebaseDatabase.instance.reference();
  static final LeaveDatabase _instance = LeaveDatabase._internal();

  factory LeaveDatabase() {
    return _instance;
  }

  LeaveDatabase._internal();

//  Future<Leave> getLeavesBasedOnUID(String uid) async {
//    DataSnapshot dataSnapshot = await _databaseReference.child("users").once();
//    final userInfo = dataSnapshot.value[uid];
//    final office = userInfo["allotted_office"];
//
//    dataSnapshot = await _databaseReference.child("location").once();
//    final findOffice = dataSnapshot.value[office];
//    final name = findOffice["name"];
//    final latitude = findOffice["latitude"];
//    final longitude = findOffice["longitude"];
//    final radius = findOffice["radius"].toDouble();
//    return Leave(
//        key: office,
//        name: name,
//        latitude: latitude,
//        longitude: longitude,
//        radius: radius);
//  }

  Future<List<Leave>> getLeaveListBasedOnUID(String uid) async {
    DataSnapshot dataSnapshot =
        await _databaseReference.child("leaves").child(uid).once();
    List<Leave> result = [];
    if (dataSnapshot == null || dataSnapshot.value == null) return result;

    var officeMap = dataSnapshot.value;
    officeMap.forEach((key, map) {
      result.add(Leave.fromJson(key, map.cast<String, dynamic>()));
    });

    return result;
  }

  Future<void> withDrawLeave(String key, String uid) async {
    var json = {"withdrawalStatus": 1};
    _databaseReference.child("leaves").child(uid).child(key).update(json);
  }
}
