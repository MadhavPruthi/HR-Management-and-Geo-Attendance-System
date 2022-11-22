import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geo_attendance_system/src/models/leave.dart';
import 'package:geo_attendance_system/src/ui/constants/leave_type.dart';

import 'fetch_leaves.dart';

class ReviewLeaveDatabase {
  final _databaseReference = FirebaseDatabase.instance.reference();
  static final ReviewLeaveDatabase _instance = ReviewLeaveDatabase._internal();
  final LeaveDatabase leaveDatabase = new LeaveDatabase();

  factory ReviewLeaveDatabase() {
    return _instance;
  }

  ReviewLeaveDatabase._internal();

  Future<dynamic> listOfAllLeaves() async {
    DataSnapshot dataSnapshot = (await _databaseReference.child("leaves").once()).snapshot;
    return dataSnapshot.value;
  }

  Future<dynamic> listOfAllUsers() async {
    DataSnapshot dataSnapshot = (await _databaseReference.child("users").once()).snapshot;
    return dataSnapshot.value;
  }

  Future<List<Leave>> getLeaveListBasedOnUID(String uid) async {
    DataSnapshot dataSnapshot =
        (await _databaseReference.child("Managers").child(uid).once()).snapshot;
    List<Leave> result = [];
    if (dataSnapshot == null) return result;
    var dataMap = dataSnapshot.value;
    var listOfUsers = await listOfAllUsers();
    var listOfLeaves = await listOfAllLeaves();

    if (dataMap != null)
      (dataMap as Map).forEach((uid, map) {
        print("UID " + uid.toString());
        String nameOfUser = listOfUsers[uid]["Name"];

        if (listOfLeaves != null && listOfLeaves[uid] != null)
          listOfLeaves[uid].forEach((leaveId, leaveMap) {
            Leave _leave =
                Leave.fromJson(leaveId, leaveMap.cast<String, dynamic>());
            _leave.name = nameOfUser;
            _leave.userUid = uid;
            result.add(_leave);
          });
      });

    return result;
  }

  Future<void> approveLeave(
      String key, String uid, int days, LeaveType leaveType) async {
    DataSnapshot dataSnapshot =( await _databaseReference
        .child("users")
        .child(uid)
        .child("leaves")
        .child(getLeaveType(leaveType))
        .once()).snapshot;
    await _databaseReference.child("users").child(uid).child("leaves").update({
      getLeaveType(leaveType): ((dataSnapshot.value as int) - days),
    });
    var json = {"status": "approved"};
    await _databaseReference.child("leaves").child(uid).child(key).update(json);
  }

  Future<void> rejectLeave(
      String key, String uid) async {
    var json = {"status": "rejected"};
    await _databaseReference.child("leaves").child(uid).child(key).update(json);
    print("done");
  }
}

String getLeaveType(LeaveType leaveType) {
  switch (leaveType) {
    case LeaveType.al:
      return "al";
      break;

    case LeaveType.ml:
      return "ml";
      break;

    case LeaveType.cl:
      return "cl";
      break;

    case LeaveType.undetermined:
      return "al";
      break;
  }
  return "al";
}
