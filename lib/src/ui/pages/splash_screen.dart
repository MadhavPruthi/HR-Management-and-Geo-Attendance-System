import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/services/authentication.dart';
import 'package:geo_attendance_system/src/ui/pages/login.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:geo_attendance_system/src/ui/pages/homepage.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class SplashScreenWidget extends StatefulWidget {
  SplashScreenWidget({this.auth});

  final BaseAuth auth;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenWidget> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      widget.auth.getCurrentUser().then((user) {
        print(user);

        setState(() {
          if (user != null) {
            _userId = user?.uid;
          }

          authStatus = user?.uid == null
              ? AuthStatus.NOT_LOGGED_IN
              : AuthStatus.LOGGED_IN;

          MaterialPageRoute loginRoute = new MaterialPageRoute(
              builder: (BuildContext context) => Login(auth: new Auth()));
          MaterialPageRoute homePageRoute = new MaterialPageRoute(
              builder: (BuildContext context) => HomePage(auth: new Auth()));

          if (authStatus == AuthStatus.LOGGED_IN) {
            Navigator.pushReplacement(context, homePageRoute);
          } else {
            if (authStatus == AuthStatus.NOT_LOGGED_IN)
              Navigator.pushReplacement(context, loginRoute);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Login(auth: new Auth()),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Color(0xffB7F8DB), Color(0xff50A7D7)],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image(
              image: AssetImage("assets/icons/Logo-splash.png"),
              height: 175,
            ),
            Container(
              padding: const EdgeInsets.only(top: 80),
              child: CircularProgressIndicator(),
            ),
          ]),
        ),
      ),
    );
  }
}
