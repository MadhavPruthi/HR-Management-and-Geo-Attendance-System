import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/ui/splash_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(body: SplashScreenWidget()),
    );
  }
}
