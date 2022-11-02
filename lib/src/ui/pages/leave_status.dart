import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/models/leave.dart';
import 'package:geo_attendance_system/src/services/fetch_leaves.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
import 'package:geo_attendance_system/src/ui/constants/leave_type.dart';
import 'package:geo_attendance_system/src/ui/widgets/loader_dialog.dart';

class LeaveStatusWidget extends StatefulWidget {
  LeaveStatusWidget({Key? key, required this.title, required this.user})
      : super(key: key);
  final String title;
  final User user;
  final FirebaseDatabase db = new FirebaseDatabase();

  @override
  LeaveStatusWidgetState createState() => LeaveStatusWidgetState();
}

class LeaveStatusWidgetState extends State<LeaveStatusWidget> {
  int y = 4;
  final LeaveDatabase leaveDatabase = new LeaveDatabase();

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

  Widget leaveList() {
    return Flexible(
      child: new Container(
        color: Colors.white,
        child: FutureBuilder(
            future: leaveDatabase.getLeaveListBasedOnUID(widget.user.uid),
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text(
                    'Press the button to fetch data',
                    textAlign: TextAlign.center,
                  );

                case ConnectionState.active:

                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(dashBoardColor)),
                  );

                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Center(
                      child: Text(
                        'Error:\n\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemExtent: 170.0,
                    itemBuilder: (context, index) {
                      return leaveRow(snapshot.data![index]);
                    },
                  );
              }
            }),
      ),
    );
  }

  Widget leaveRow(Leave leave) {
    final thumbnail = new Container(
      alignment: new FractionalOffset(0.0, 0.5),
      margin: const EdgeInsets.only(left: 15.0),
      child: new Hero(
          tag: leave.key,
          child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(width: 5, color: getColor(leave.status))),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: getIcon(leave.status),
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
              color: Colors.black,
              blurRadius: 10.0,
              offset: new Offset(0.0, 2.0))
        ],
      ),
      child: new Container(
        margin: const EdgeInsets.only(top: 16.0, left: 72.0),
        constraints: new BoxConstraints.expand(),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Text(getLeaveType(leave.type),
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontFamily: 'poppins-medium',
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                )),
            new Text(
                getFormattedDate(leave.fromDate) +
                    " - " +
                    getFormattedDate(leave.toDate),
                style: TextStyle(
                  color: Color(0x66FFFFFF),
                  fontFamily: 'poppins-medium',
                  fontWeight: FontWeight.w300,
                  fontSize: 14.0,
                )),
//            Container(
//              color: Colors.white70,
//              width: 170.0,
//              height: 1.0,
//              margin: const EdgeInsets.symmetric(vertical: 8.0),
//            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: new Icon(Icons.calendar_today,
                      size: 14.0, color: Color(0x66FFFFFF)),
                ),
                new Text(
                  leave.withdrawalStatus == false
                      ? getStatus(leave.status)
                      : "Withdrawn",
                  style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'poppins-medium',
                      fontWeight: FontWeight.w300,
                      fontSize: 14.0),
                ),
                new Container(width: 70.0),
                leave.status == LeaveStatus.approved ||
                        leave.status == LeaveStatus.rejected ||
                        leave.withdrawalStatus == true
                    ? Container(
                        height: 35,
                      )
                    : new ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith(
                            (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          elevation:
                              MaterialStateProperty.resolveWith((states) => 4),
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.purple,
                          ),
                        ),
                        onPressed: () async {
                          onLoadingDialog(context);
                          leaveDatabase
                              .withDrawLeave(leave.key, widget.user.uid)
                              .then((_) {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {});
                          });
                        },
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
                                  fontSize: 10.0),
                            ),
                          ]),
                        ),
                      )
              ],
            ),
            new Text("Applied on" + " " + getFormattedDate(leave.appliedDate),
                style: TextStyle(
                    color: Color(0x66FFFFFF),
                    fontFamily: 'poppins-medium',
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                    letterSpacing: 1)),
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
}

List<Icon> listOfIcons = [
  Icon(
    Icons.check,
    size: 60,
    color: Colors.green,
  ),
  Icon(
    Icons.hourglass_empty,
    size: 60,
    color: Colors.orange,
  ),
  Icon(
    Icons.cancel,
    size: 60,
    color: Colors.red,
  )
];

List<Color> listOfColors = [Colors.green, Colors.orange, Colors.red];

Icon getIcon(LeaveStatus leaveStatus) {
  switch (leaveStatus) {
    case LeaveStatus.approved:
      return listOfIcons[0];
      break;

    case LeaveStatus.pending:
      return listOfIcons[1];
      break;

    case LeaveStatus.rejected:
      return listOfIcons[2];
      break;

    case LeaveStatus.undetermined:
      return listOfIcons[2];
      break;
  }
  return listOfIcons[2];
}

Color getColor(LeaveStatus leaveStatus) {
  switch (leaveStatus) {
    case LeaveStatus.approved:
      return listOfColors[0];
      break;

    case LeaveStatus.pending:
      return listOfColors[1];
      break;

    case LeaveStatus.rejected:
      return listOfColors[2];
      break;

    case LeaveStatus.undetermined:
      return listOfColors[2];
      break;
  }
  return listOfColors[2];
}

String getStatus(LeaveStatus leaveStatus) {
  switch (leaveStatus) {
    case LeaveStatus.approved:
      return "Approved";
      break;

    case LeaveStatus.pending:
      return "Pending";
      break;

    case LeaveStatus.rejected:
      return "Rejected";
      break;

    case LeaveStatus.undetermined:
      return "Pending";
      break;
  }
  return "Pending";
}

String getDoubleDigit(String value) {
  if (value.length >= 2) return value;
  return "0" + value;
}

String getFormattedDate(DateTime day) {
  String formattedDate = getDoubleDigit(day.day.toString()) +
      "-" +
      getDoubleDigit(day.month.toString()) +
      "-" +
      getDoubleDigit(day.year.toString());
  return formattedDate;
}

String getLeaveType(LeaveType leaveType) {
  switch (leaveType) {
    case LeaveType.al:
      return "Annual Leave";
      break;

    case LeaveType.ml:
      return "Medical Leave";
      break;

    case LeaveType.cl:
      return "Casual Leave";
      break;

    case LeaveType.undetermined:
      return "Leave";
      break;
  }
  return "Leave";
}
