import 'package:flutter/material.dart';

Widget buildTile(IconData icon, String title, String subtitle,
    {Function() onTap}) {
  return Material(
      elevation: 10.0,
      shadowColor: Colors.deepPurpleAccent,
      borderRadius: BorderRadius.circular(12.0),
      color: Colors.deepPurpleAccent,
      child: InkWell(
        // Do onTap() if it isn't null, otherwise do print()
        onTap: onTap != null
            ? () => onTap()
            : () {
                print('Not set yet');
              },
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
                Text(subtitle,
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
