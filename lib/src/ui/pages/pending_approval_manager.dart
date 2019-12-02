import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/models/leave.dart';
import 'package:geo_attendance_system/src/services/fetch_pending_leaves.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
import 'package:geo_attendance_system/src/ui/constants/leave_type.dart';
import 'package:geo_attendance_system/src/ui/widgets/loader_dialog.dart';

class LeaveApprovalByManagerWidget extends StatefulWidget {
  LeaveApprovalByManagerWidget({Key key, this.title, this.user})
      : super(key: key);
  final String title;
  final FirebaseUser user;
  final FirebaseDatabase db = new FirebaseDatabase();

  @override
  LeaveApprovalByManagerWidgetState createState() =>
      LeaveApprovalByManagerWidgetState();
}

class LeaveApprovalByManagerWidgetState
    extends State<LeaveApprovalByManagerWidget> {
  final ReviewLeaveDatabase reviewLeaveDatabase = new ReviewLeaveDatabase();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Review Leaves'.toUpperCase()),
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
            future: reviewLeaveDatabase.getLeaveListBasedOnUID(widget.user.uid),
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
                    itemCount: snapshot.data.length,
//                    itemExtent: 200.0,
                    itemBuilder: (context, index) {
                      Leave leave = snapshot.data[index];
                      if (leave.status == LeaveStatus.pending &&
                          leave.withdrawalStatus == false)
                        return leaveRow(snapshot.data[index]);

                      return Container();
                    },
                  );
              }
            }),
      ),
    );
  }

  Widget leaveRow(Leave leave) {
    final leaveCard = new Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
      decoration: new BoxDecoration(
        color: dashBoardColor,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
              color: Colors.black38,
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
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text(
                  "Message: ${leave.message}",
                  style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'poppins-medium',
                      fontWeight: FontWeight.w300,
                      fontSize: 14.0),
                ),
              ],
            ),
            Expanded(
              child: new Text(
                  "Applied on" +
                      " " +
                      getFormattedDate(leave.appliedDate) +
                      " by " +
                      leave.name,
                  style: TextStyle(
                      color: Color(0x66FFFFFF),
                      fontFamily: 'poppins-medium',
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                      letterSpacing: 1)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    onPressed: () async {
                      onLoadingDialog(context);
                      int days = leave.toDate.difference(leave.fromDate).inDays;
                      reviewLeaveDatabase
                          .approveLeave(
                              leave.key, leave.userUid, days, leave.type)
                          .then((_) {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      });
                      Future.delayed(Duration(seconds: 1), () {
                        setState(() {});
                      });
                    },
                    textColor: Color(0x66FFFFFF),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(children: <Widget>[
                        new Icon(Icons.check_circle,
                            size: 20.0, color: Color(0x66FFFFFF)),
                        new Text(
                          'Approve',
                          style: TextStyle(
                              color: Color(0x66FFFFFF),
                              fontFamily: 'poppins-medium',
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0),
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  RaisedButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    onPressed: () async {
                      onLoadingDialog(context);
                      reviewLeaveDatabase
                          .rejectLeave(leave.key, leave.userUid)
                          .then((_) {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        Future.delayed(Duration(seconds: 1), () {
                          setState(() {});
                        });
                      });
                    },
                    textColor: Color(0x66FFFFFF),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(children: <Widget>[
                        new Icon(Icons.clear,
                            size: 20.0, color: Color(0x66FFFFFF)),
                        new Text(
                          'Reject',
                          style: TextStyle(
                              color: Color(0x66FFFFFF),
                              fontFamily: 'poppins-medium',
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
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
        ],
      ),
    );
  }
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

DateTime formattedProperDateTime(String date) {
  return DateTime.parse(
      date.toString().split("-").reversed.join("-").toString() + " 01:00:00");
}
