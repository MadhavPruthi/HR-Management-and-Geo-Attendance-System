import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
import 'package:geo_attendance_system/src/ui/widgets/loader_dialog.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

import 'leave_status.dart';

class LeaveApplicationWidget extends StatefulWidget {
  LeaveApplicationWidget({Key? key, required this.title, required this.user})
      : super(key: key);
  final String title;
  final User user;
  final FirebaseDatabase db = new FirebaseDatabase();

  @override
  LeaveApplicationWidgetState createState() => LeaveApplicationWidgetState();
}

class LeaveApplicationWidgetState extends State<LeaveApplicationWidget>
    with SingleTickerProviderStateMixin {
  FirebaseDatabase db = FirebaseDatabase();
  User? _user;
  late DatabaseReference _userRef, _managerRef, _leaveRef;
  String _managerName = '', _managerDesignation = '';

  String _fromdate = "Select";
  DateTime? _fromDateInt;

  bool isSelected = false;
  String _todate = "Select";
  DateTime? _toDateInt;
  var date = DateTime.now();

  bool ishalfday = false;
  String? leave_type;
  int? nofdays;
  bool monVal = false;

  List<String> _checked = [];
  final _formKey = GlobalKey<FormState>();

  String leavesCount = "-";
  String msg = "none";

  List<String> leaveType = [
    "Medical Leave",
    "Annual Leave",
    "Casual Leave",
  ];

  List<String> leaveKeys = [
    "ml",
    "al",
    "cl",
  ];

  int leaveIndex = -1;
  List<Widget> list = [];

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _userRef = db.reference().child("users");
    _leaveRef = db.reference().child("leaves");
    _managerRef = db.reference().child("managers");
    _getManager();
    _getLeaves().then((DatabaseEvent databaseEvent) {
      setState(() {
        list = _generateListLeaves(databaseEvent.snapshot);
      });
    });
  }

  void _getManager() async {
    _userRef
        .child(widget.user.uid)
        .child("manager")
        .once()
        .then((DatabaseEvent event) {
      final managerID = event.snapshot;
      _managerRef
          .child(managerID.value as String)
          .once()
          .then((DatabaseEvent _event) {
        final details = _event.snapshot;
        if (mounted) {
          setState(() {
            _managerName = (details.value as Map)["name"];
            _managerDesignation = (details.value as Map)["designation"];
          });
        }
      });
    });
  }

  Future<DatabaseEvent> _getLeaves() async {
    return _userRef.child(widget.user.uid).child("leaves").once();
  }

  List<Widget> _generateListLeaves(DataSnapshot dataSnapshot) {
    List<Widget> list = [];
    (dataSnapshot.value as Map?)?.forEach((key, value) {
      list.add(Container(
          decoration: BoxDecoration(
              color: dashBoardColor,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.white60, width: 3)),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              "${key.toString().toUpperCase()} - $value",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "poppins-medium"),
            ),
          )));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: TextTheme(
              bodyText1: TextStyle(
                  color: Colors.black87,
                  fontFamily: "poppins-medium",
                  fontSize: 15,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w400),
              button: TextStyle(
                  color: Colors.black87,
                  fontFamily: "poppins-medium",
                  fontSize: 18,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900))),
      home: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Leave Application'),
            backgroundColor: appbarcolor,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Builder(
                      builder: (context) => Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Text(
                                    "Available Leaves",
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: list == null
                                        ? LinearProgressIndicator()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: list,
                                          )),
                                Text("Your Manager"),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 20),
                                  child: TextFormField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        labelText: (_managerName == null)
                                            ? ("Loading")
                                            : (_managerName),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.redAccent,
                                              width: 5.0),
                                        ),
                                      ),
                                      onTap: () {
                                        _showDialog(context);
                                      }),
                                ),
                                Text("Today's Date"),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 20),
                                  child: TextField(
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText:
                                          '${date.year}-${date.month}-${date.day}',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black45, width: 1.0),
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text('From'),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 20),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty
                                                .resolveWith(
                                              (states) =>
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            elevation: MaterialStateProperty
                                                .resolveWith((states) => 4),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        Colors.white),
                                          ),
                                          onPressed: () {
                                            DatePicker.showDatePicker(context,
                                                theme: DatePickerTheme(
                                                  containerHeight: 250.0,
                                                ),
                                                showTitleActions: true,
                                                minTime: DateTime(date.year,
                                                    date.month, date.day),
                                                maxTime: DateTime(2050, 12, 31),
                                                onConfirm: (date) {
                                              print('confirm $date');
                                              _fromdate =
                                                  getFormattedDate(date);
                                              setState(() {
                                                _fromDateInt = date;

                                                if (_todate != null) {
                                                  setState(() {
                                                    int _difference = _toDateInt
                                                            ?.difference(
                                                                _fromDateInt ??
                                                                    _toDateInt!)
                                                            .inDays ??
                                                        0;
                                                    _difference += 1;
                                                    if (_difference <= 0)
                                                      leavesCount =
                                                          "Invalid Dates";
                                                    else
                                                      leavesCount = _difference
                                                          .toString();
                                                  });
                                                }
                                              });
                                            },
                                                currentTime: DateTime.now(),
                                                locale: LocaleType.en);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 50.0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            "$_fromdate",
                                                            style: TextStyle(
                                                              color:
                                                                  dashBoardColor,
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                    Text('To'),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 20),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty
                                                .resolveWith(
                                              (states) =>
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            elevation: MaterialStateProperty
                                                .resolveWith((states) => 4),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        Colors.white),
                                          ),
                                          onPressed: () {
                                            DatePicker.showDatePicker(context,
                                                theme: DatePickerTheme(
                                                  containerHeight: 250.0,
                                                ),
                                                showTitleActions: true,
                                                minTime: DateTime(date.year,
                                                    date.month, date.day),
                                                maxTime: DateTime(2022, 12, 31),
                                                onConfirm: (date) {
                                              print('confirm $date');
                                              _todate = getFormattedDate(date);
                                              setState(() {
                                                _toDateInt = date;

                                                if (_fromDateInt != null) {
                                                  setState(() {
                                                    int _difference = _toDateInt
                                                            ?.difference(
                                                                _fromDateInt ??
                                                                    _toDateInt!)
                                                            .inDays ??
                                                        0;
                                                    _difference += 1;
                                                    if (_difference <= 0)
                                                      leavesCount =
                                                          "Invalid Dates";
                                                    else
                                                      leavesCount = _difference
                                                          .toString();
                                                  });
                                                }
                                              });
                                            },
                                                currentTime: DateTime.now(),
                                                locale: LocaleType.en);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 50.0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            "$_todate",
                                                            style: TextStyle(
                                                                color:
                                                                    dashBoardColor,
                                                                fontSize: 16.0),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                                Container(
                                  child: Text(
                                      'Number of days on leave: $leavesCount'),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Text('Type of leave'),
                                ),
                                CheckboxGroup(
                                  labels: <String>[
                                    leaveType[0],
                                    leaveType[1],
                                    leaveType[2],
                                  ],
                                  checked: _checked,
                                  activeColor: dashBoardColor,
                                  onChange: (bool isChecked, String label,
                                      int index) {
                                    print(
                                        "isChecked: $isChecked   label: $label  index: $index");
                                    leaveIndex = index;
                                  },
                                  onSelected: (selected) => setState(() {
                                    isSelected = true;
                                    if (selected.length > 1) {
                                      selected.removeAt(0);
                                      print(
                                          'selected length  ${selected.length}');
                                    } else {
                                      print("only one");
                                    }
                                    _checked = selected;
                                  }),
                                ),
                                TextField(
                                  autofocus: false,
                                  //controller: emailController,
                                  //onSubmitted: _giveData(emailController),
                                  decoration: new InputDecoration(
                                    labelText:
                                        "Message for Management (Optional)",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black54),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black54),
                                    ),
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 16.0),
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape:
                                              MaterialStateProperty.resolveWith(
                                            (states) => RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                          elevation:
                                              MaterialStateProperty.resolveWith(
                                                  (states) {
                                            if (states.contains(
                                                MaterialState.hovered)) {
                                              return 40;
                                            } else {
                                              return 4;
                                            }
                                          }),
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) {
                                            if (states.contains(
                                                MaterialState.hovered)) {
                                              return splashScreenColorBottom;
                                            } else {
                                              return splashScreenColorTop;
                                            }
                                          }),
                                        ),
                                        onPressed: () {
                                          if (_validateData(context)) {
                                            onLoadingDialog(context);

                                            addLeave().then((check) {
                                              if (check == true) {
                                                pushData(context).then((_) {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop('dialog');
                                                  SnackBar data = new SnackBar(
                                                    action: SnackBarAction(
                                                        textColor:
                                                            Colors.white70,
                                                        label: "View",
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                                builder: (context) =>
                                                                    LeaveStatusWidget(
                                                                        title:
                                                                            "Leave Status",
                                                                        user: widget
                                                                            .user)),
                                                          );
                                                        }),
                                                    content: Text(
                                                        "Leave has been requested\nA notification will be sent to you once it is approved!",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white)),
                                                    backgroundColor:
                                                        Colors.blue,
//                                                duration: Duration(seconds: 1),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(data);
                                                });
                                              } else {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop('dialog');
                                                SnackBar error = new SnackBar(
                                                  content: Text(
                                                      "You don't have enough requested leaves",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  backgroundColor: Colors.red,
                                                );

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(error);
                                              }
                                            });
//
                                            //msg =  msgManagement.text;
                                          }
                                        },
                                        child: Text('Submit',
                                            style: TextStyle(
                                                color: Colors.white)))),
                              ])))))),
    );
  }

  void giveData(TextEditingController controller) {
    msg = controller.text;
  }

  Future<void> pushData(BuildContext context) async {
    if (leaveIndex == 0) {
//        _userRef.child(widget.user.uid).child("leaves").update({'ml': count});
      await _leaveRef.child(widget.user.uid).push().set({
        'fromDate': '$_fromdate',
        'toDate': '$_todate',
        'status': 'pending',
        'type': 'ml',
        'withdrawalStatus': 0,
        'appliedDate': getFormattedDate(date),
        'message': 'none'
      });
    } else if (leaveIndex == 1) {
//        _userRef.child(widget.user.uid).child("leaves").update({'al': count});
      await _leaveRef.child(widget.user.uid).push().set({
        'fromDate': '$_fromdate',
        'toDate': '$_todate',
        'status': 'pending',
        'type': 'al',
        'withdrawalStatus': 0,
        'appliedDate': getFormattedDate(date),
        'message': 'none'
      });
    } else {
//        _userRef.child(widget.user.uid).child("leaves").update({'cl': count});
      await _leaveRef.child(widget.user.uid).push().set({
        'fromDate': '$_fromdate',
        'toDate': '$_todate',
        'status': 'pending',
        'type': 'cl',
        'withdrawalStatus': 0,
        'appliedDate': getFormattedDate(date),
        'message': 'none'
      });
    }
  }

  Future<bool> addLeave() async {
    int request = int.parse(leavesCount);

    DataSnapshot dataSnapshot = (await _userRef
            .child(widget.user.uid)
            .child("leaves")
            .child(leaveKeys[leaveIndex])
            .once())
        .snapshot;
//    print("Value" +  dataSnapshot.key.toString() + " " + dataSnapshot.value.toString());
//    print(request);
    if ((dataSnapshot.value as int) < request) {
      return false;
    } else
      return true;
  }

  bool _validateData(BuildContext context) {
    bool returnVal = true;

    if (leavesCount == "-" || leavesCount == "Invalid Dates") {
      SnackBar error = new SnackBar(
        content: Text("Please enter valid dates",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(error);
      returnVal = false;
    }

    if (leaveIndex == -1) {
      SnackBar error = new SnackBar(
        content: Text("Please select type of leave valid dates",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(error);
      returnVal = false;
    }

    return returnVal;
  }

  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Center(child: Text("Manager Details")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text((_managerName == null) ? ("Loading ..") : (_managerName)),
              Text((_managerDesignation == null)
                  ? ("Loading")
                  : (_managerDesignation)),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
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
