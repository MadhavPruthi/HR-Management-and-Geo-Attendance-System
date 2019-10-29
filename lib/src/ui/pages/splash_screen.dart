import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/ui/pages/login.dart';
import 'package:splashscreen/splashscreen.dart';

import 'package:geo_attendance_system/src/ui/pages/homepage.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 4,
      navigateAfterSeconds: Login(),
      image: Image(
        image: AssetImage("assets/icons/Logo-splash.png"),
      ),
      photoSize: 140.0,
      gradientBackground: LinearGradient(
        colors: const [Color(0xffB7F8DB), Color(0xff50A7D7)],
        begin: Alignment.bottomCenter,
        end: Alignment.topRight,
      ),
      loaderColor: Colors.blueGrey,
    );
  }
}
