import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/services/authentication.dart';
import 'package:geo_attendance_system/src/services/geofencing.dart';

import 'package:geo_attendance_system/src/ui/pages/splash_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GeoFencing(
      service: GeoFencingService(),
      child: MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: SplashScreenWidget(
            auth: new Auth(),
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
