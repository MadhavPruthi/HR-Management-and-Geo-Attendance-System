import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';

class LeaveApplicationWidget extends StatefulWidget {
  LeaveApplicationWidget({Key key, this.title, this.user}) : super(key: key);
  final String title;
  final FirebaseUser user;
  @override
  LeaveApplicationWidgetState createState() => LeaveApplicationWidgetState();
}

class LeaveApplicationWidgetState extends State<LeaveApplicationWidget> {
  String _fromdate = "Select";

  String _todate = "Select";
  var date=DateTime.now();

  bool ishalfday = false;
  String leave_type;
  int nofdays;
  bool monVal=false;
  bool medical_leave = false;
  bool annual_leave = false;
  bool casual_leave = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Leave Application'),
          backgroundColor: Colors.red,
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
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: TextFormField( readOnly: true,

                                  decoration: InputDecoration(

                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.redAccent, width: 5.0),
                                      ),
                                      ),
                                ),
                              ),
                              Text('Today'),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                    child: TextFormField( readOnly: true,

                                      decoration: InputDecoration(
                                        labelText: '${date.year} - ${date.month} - ${date.day}',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.redAccent, width: 5.0),
                                          ),
                                          ),

                                    ),
                                  ),
                              Text('From'),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: RaisedButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    elevation: 4.0,
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          theme: DatePickerTheme(
                                            containerHeight: 210.0,
                                          ),
                                          showTitleActions: true,
                                          minTime: DateTime(2000, 1, 1),
                                          maxTime: DateTime(2022, 12, 31),
                                          onConfirm: (date) {
                                        print('confirm $date');
                                        _fromdate =
                                            '${date.year} - ${date.month} - ${date.day}';
                                        setState(() {});
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "$_fromdate",
                                                      style: TextStyle(
                                                        color: Colors
                                                            .redAccent,
                                                        fontSize: 18.0,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: RaisedButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    elevation: 4.0,
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          theme: DatePickerTheme(
                                            containerHeight: 210.0,
                                          ),
                                          showTitleActions: true,
                                          minTime: DateTime(2000, 1, 1),
                                          maxTime: DateTime(2022, 12, 31),
                                          onConfirm: (date) {
                                        print('confirm $date');
                                        _todate =
                                            '${date.year} - ${date.month} - ${date.day}';
                                        setState(() {});
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "$_todate",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .redAccent,
                                                          fontSize: 18.0),
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
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: Text('Number of days on leave'),
                              ),
                              Container(
                                child: DropdownButton<int>(
                                  items: [
                                    DropdownMenuItem<int>(
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(width: 1),
                                          Text(
                                            "1",
                                          ),
                                        ],
                                      ),
                                      value: 1,
                                    ),
                                    DropdownMenuItem<int>(
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(width: 1),
                                          Text(
                                            "2",
                                            style: TextStyle(
                                              fontFamily: "Poppins-medium",
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: 2,
                                    ),
                                    DropdownMenuItem<int>(
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(width: 1),
                                          Text(
                                            "3",
                                          ),
                                        ],
                                      ),
                                      value: 3,
                                    ),
                                  ],
                                  onChanged: (int value) {
                                    setState(() {
                                      nofdays = value;
                                    });
                                  },
                                  hint: Text('Select Item'),
                                  value: nofdays,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 50, 0, 20),
                                child: Text('Type of leave'),
                              ),
                                  CheckboxListTile(
                                    title:const Text('Meidcal Leave'),
                                    value: medical_leave,
                                    activeColor: Colors.redAccent,
                                    checkColor: Colors.white,
                                    onChanged: (value) {
                                      setState(() {
                                        medical_leave = value;
                                      });
                                    },
                                  ),

                              CheckboxListTile(
                                  title: const Text('Annual Leave'),
                                  value: annual_leave,
                                  activeColor: Colors.redAccent,
                                  checkColor: Colors.white,

                                  onChanged: (value) {
                                    setState(() => annual_leave = value);
                                  }),
                              CheckboxListTile(
                                  title: const Text('Casual Leave'),
                                  value: casual_leave,
                                  activeColor: Colors.redAccent,
                                  checkColor: Colors.white,
                                  onChanged: (value) {
                                    setState(() => casual_leave = value);
                                  }),
                                  TextField(
                                    decoration: new InputDecoration(

                                        labelText: "Message for Management",
                                        labelStyle: new TextStyle(color: Colors.redAccent),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.redAccent),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.redAccent),
                                      ),
                                    ),
                                  ),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 16.0),
                                  child: RaisedButton(
                                      color: splashScreenColorTop,
                                      onPressed: () {},
                                      child: Text('Submit',style: TextStyle(color: Colors.white)))),
                            ]))))));
  }
}
