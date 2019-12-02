import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geo_attendance_system/src/models/user.dart';

class UserDatabase {
  static final _databaseReference = FirebaseDatabase.instance.reference();
  static final UserDatabase _instance = UserDatabase._internal();

  factory UserDatabase() {
    return _instance;
  }

  UserDatabase._internal();

  static Future<Employee> getDetailsFromUID(String uid) async {
    DataSnapshot dataSnapshot =
        await _databaseReference.child("users").child(uid).once();
    final profile = dataSnapshot.value;
    return Employee(
        employeeID: profile["UID"].toString(),
        firstName: profile["Name"],
        contactNumber: profile["PhoneNumber"].toString(),
        residentialAddress: profile["Address"],
        designation: profile["designation"]);
  }
}
