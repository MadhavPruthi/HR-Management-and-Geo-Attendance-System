import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';

class LeaveStatusWidget extends StatefulWidget {
  LeaveStatusWidget({Key key, this.title, this.user}) : super(key: key);
  final String title;
  final FirebaseUser user;
  final FirebaseDatabase db = new FirebaseDatabase();

  @override
  LeaveStatusWidgetState createState() => LeaveStatusWidgetState();
}

class LeaveStatusWidgetState extends State<LeaveStatusWidget> {
  int y = 4;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Leave Status'.toUpperCase()),
          backgroundColor: appbarcolor,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: <Widget>[
            leaveList(),
          ],
        ));
  }
}

int y = 4;

List<Icon> listOfIcons = [
  Icon(
    Icons.check,
    size: 60,
    color: Colors.green,
  ),
  Icon(
    Icons.hourglass_empty,
    size: 50,
    color: Colors.orange,
  ),
  Icon(
    Icons.cancel,
    size: 40,
    color: Colors.red,
  )
];

List<Color> listOfColors = [Colors.green, Colors.orange, Colors.red];

Widget leaveList() {
  return Flexible(
    child: new Container(
      color: Colors.white,
      child: ListView.builder(
          itemExtent: 170.0,
          itemCount: 10,
          itemBuilder: (_, index) => leaveRow(1)),
    ),
  );
}

Widget leaveRow(double x) {
  final thumbnail = new Container(
    alignment: new FractionalOffset(0.0, 0.5),
    margin: const EdgeInsets.only(left: 15.0),
    child: new Hero(
        tag: 'planet-icon-${y--}',
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(width: 5, color: listOfColors[1])),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: listOfIcons[1],
            ))),
  );
  final leaveCard = new Container(
    height: 200,
    margin: const EdgeInsets.only(left: 45.0, right: 20.0),
    decoration: new BoxDecoration(
      color: Color(0xFF8685E5),
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.circular(8.0),
      boxShadow: <BoxShadow>[
        new BoxShadow(
            color: Colors.black, blurRadius: 10.0, offset: new Offset(0.0, 2.0))
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
                fontFamily: 'poppins-medium',
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              )),
          new Text('Date',
              style: TextStyle(
                color: Color(0x66FFFFFF),
                fontFamily: 'poppins-medium',
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: new Icon(Icons.calendar_today,
                    size: 14.0, color: Color(0x66FFFFFF)),
              ),
              new Text(
                'approved',
                style: TextStyle(
                    color: Color(0x66FFFFFF),
                    fontFamily: 'poppins-medium',
                    fontWeight: FontWeight.w300,
                    fontSize: 12.0),
              ),
              new Container(width: 70.0),
              new RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                onPressed: null,
                textColor: Color(0x66FFFFFF),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(children: <Widget>[
                    new Icon(Icons.arrow_upward,
                        size: 20.0, color: Color(0x66FFFFFF)),
                    new Text(
                      'Withdraw',
                      style: TextStyle(
                          color: Color(0x66FFFFFF),
                          fontFamily: 'poppins-medium',
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0),
                    ),
                  ]),
                ),
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
    margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
    child: new Stack(
      children: <Widget>[
        leaveCard,
        thumbnail,
      ],
    ),
  );
}

void _removeLeave() {}
