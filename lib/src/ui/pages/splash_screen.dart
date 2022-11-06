import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geo_attendance_system/src/services/authentication.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
import 'package:geo_attendance_system/src/ui/pages/homepage.dart';
import 'package:geo_attendance_system/src/ui/pages/login.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class SplashScreenWidget extends StatefulWidget {
  SplashScreenWidget({required this.auth});

  final BaseAuth auth;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenWidget> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;


  void initState() {
    super.initState();


    Timer(Duration(seconds: 3), () {
      widget.auth.getCurrentUser().then((user) {
        setState(() {          
          authStatus = user?.uid == null
              ? AuthStatus.NOT_LOGGED_IN
              : AuthStatus.LOGGED_IN;

          if (authStatus == AuthStatus.LOGGED_IN) {
            MaterialPageRoute homePageRoute = new MaterialPageRoute(
                builder: (BuildContext context) => HomePage(user: user!));
            Navigator.pushReplacement(context, homePageRoute);
          } else {
            if (authStatus == AuthStatus.NOT_LOGGED_IN)
              {
                MaterialPageRoute loginRoute = new MaterialPageRoute(
                    builder: (BuildContext context) => Login(auth: new Auth()));
                Navigator.pushReplacement(context, loginRoute);
              }

          }
        });
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [splashScreenColorBottom, splashScreenColorTop],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              "assets/logo/logo-white.png",
              height: 150,
            ),
            Container(
              padding: const EdgeInsets.only(top: 80),
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
