import 'package:flutter/material.dart';

import 'package:geo_attendance_system/src/ui/pages/splash_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData.light(),
      home: Scaffold(body: SplashScreenWidget()),
      debugShowCheckedModeBanner: false,
    );
  }
}
