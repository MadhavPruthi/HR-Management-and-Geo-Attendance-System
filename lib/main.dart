import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geo_attendance_system/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}
