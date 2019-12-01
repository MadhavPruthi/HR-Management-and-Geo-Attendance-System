import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
import 'package:geo_attendance_system/src/ui/widgets/loader_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class LeaveStatusWidget extends StatefulWidget {
  LeaveStatusWidget({Key key, this.title, this.user}) : super(key: key);
  final String title;
  final FirebaseUser user;
  FirebaseDatabase db = new FirebaseDatabase();

  @override
  LeaveStatusWidgetState createState() => LeaveStatusWidgetState();
}

class LeaveStatusWidgetState extends State<LeaveStatusWidget>
    with SingleTickerProviderStateMixin {int y=4;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Leave Status'),
          backgroundColor: splashScreenColorTop,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: <Widget>[
            leavelist(),
          ],
        ));
  }
}

Widget leavelist() {
  return Flexible(
    child: new Container(
      color: Colors.white,
      child: ListView.builder(
          itemExtent: 170.0,
          itemCount: 1,
          itemBuilder: (_, index) => leaveRow(1)),
    ),
  );
}

Widget leaveRow(double x) {
  int y=4;
  final thumbnail = new Container(
    alignment: new FractionalOffset(0.0, 0.5),
    margin: const EdgeInsets.only(left: 24.0),
    child: new Hero(
      tag: 'planet-icon-${y--}',
      child: new Image(
        image: new AssetImage('assets/icons/tick.png'),
        height: 100.0,
        width: 100.0,
      ),
    ),
  );
  final leaveCard = new Container(
    margin: const EdgeInsets.only(left: 52.0, right: 14.0),
    decoration: new BoxDecoration(
      color: Color(0xFF8685E5),
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.circular(8.0),
      boxShadow: <BoxShadow>[
        new BoxShadow(
            color: Colors.black,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0))
      ],
    ),
    child: new Container(
      margin: const EdgeInsets.only(top: 16.0, left: 72.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text('Type of Leave',
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 36.0,
              )),
          new Text('Date',
              style: TextStyle(
                color: Color(0x66FFFFFF),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                fontSize: 14.0,
              )),
          Container(
            color: const Color(0xFF00C6FF),
            width: 24.0,
            height: 1.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          new Row(
            children: <Widget>[
              new Icon(Icons.calendar_today,
                  size: 14.0, color: Color(0x66FFFFFF)),
              new Text(
                'approved',
                style: TextStyle(
                    color: Color(0x66FFFFFF),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                    fontSize: 12.0),
              ),
              new Container(width: 24.0),
              new RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                onPressed: null,
                textColor: Color(0x66FFFFFF),
                child: Column(children: <Widget>[
                  new Icon(Icons.arrow_upward,
                      size: 14.0, color: Color(0x66FFFFFF)),
                  new Text(
                    'Withdraw',
                    style: TextStyle(
                        color: Color(0x66FFFFFF),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0),
                  ),
                ]),
              )
              /*
            ,*/
            ],
          )
        ],
      ),
    ),
  );
  return new Container(
    height: 120.0,
    margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
    child: new Stack(
      children: <Widget>[
        leaveCard,
        thumbnail,
      ],
    ),
  );
}


void _removeleave()
{

}