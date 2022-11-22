import 'package:flutter/material.dart';

void showDialogTemplate(BuildContext context, String title, String subtitle,
    String gif, Color color, String buttonText) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 40,
        child: AlertDialog(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                gif,
                width: 175,
              ),
              Text(subtitle, style: TextStyle(color: Colors.white60)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.resolveWith(
                  (states) => EdgeInsets.symmetric(horizontal: 16.0),
                ),
                shape: MaterialStateProperty.resolveWith(
                  (states) => const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.blue,
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
