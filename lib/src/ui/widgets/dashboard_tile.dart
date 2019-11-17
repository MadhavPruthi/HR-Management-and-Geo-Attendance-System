import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';

Widget buildTile(IconData icon, String title, String subtitle,
    BuildContext context, FirebaseUser user,
    [Function(BuildContext,FirebaseUser) onTap]) {
  return Material(
      elevation: 10.0,
      shadowColor: dashBoardColor,
      borderRadius: BorderRadius.circular(12.0),
      color: dashBoardColor,
      child: InkWell(
        onTap: onTap != null
            ? () {
                onTap(context,user);
              } //  Implement here onTap function
            : () => print("Not yet set"),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Material(
                    color: Colors.white70,
                    shape: CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(icon, color: Colors.deepPurple, size: 30.0),
                    )),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ]),
        ),
      ));
}
