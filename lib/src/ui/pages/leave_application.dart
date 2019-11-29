import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
import 'package:geo_attendance_system/src/ui/widgets/loader_dialog.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class LeaveApplicationWidget extends StatefulWidget {
  LeaveApplicationWidget({Key key, this.title, this.user}) : super(key: key);
  final String title;
  final FirebaseUser user;
  FirebaseDatabase db = new FirebaseDatabase();

  @override
  LeaveApplicationWidgetState createState() => LeaveApplicationWidgetState();
}

class LeaveApplicationWidgetState extends State<LeaveApplicationWidget>
    with SingleTickerProviderStateMixin {
  FirebaseDatabase db = FirebaseDatabase();
  DatabaseReference _userRef, _managerRef;
  String _managerName, _managerDesignation;

  String _fromdate = "Select";
  DateTime _fromDateInt;
  int currentState = 0;

  String _todate = "Select";
  DateTime _toDateInt;
  var date = DateTime.now();

  bool ishalfday = false;
  String leave_type;
  int nofdays;
  bool monVal = false;

  List<String> _checked = [];
  final _formKey = GlobalKey<FormState>();

  String leavesCount = "-";

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

  String _errorMessage;

  @override
  void initState() {
    super.initState();
    _userRef = db.reference().child("users");
    _managerRef = db.reference().child("managers");
    _getManager();
  }

  void _getManager() async {
    _userRef
        .child(widget.user.uid)
        .child("manager")
        .once()
        .then((DataSnapshot managerID) {
      _managerRef.child(managerID.value).once().then((DataSnapshot details) {
        setState(() {
          _managerName = details.value["name"];
          _managerDesignation = details.value["designation"];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Leave Application'),
          backgroundColor: dashBoardColor,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                /*decoration: BoxDecoration(
                      gradient: LinearGradient(
                      colors: const [splashScreenColorBottom, splashScreenColorTop],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topRight,
                      ),),*/
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Builder(
                    builder: (context) => Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("Your Manager"),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
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
                                  ),
                                ),
                              
                              Text("Today's Date"),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
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
                              Text('From'),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 20),
                                  child: RaisedButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    elevation: 4.0,
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          theme: DatePickerTheme(
                                            containerHeight: 250.0,
                                          ),
                                          showTitleActions: true,
                                          minTime: DateTime(2000, 1, 1),
                                          maxTime: DateTime(2022, 12, 31),
                                          onConfirm: (date) {
                                        print('confirm $date');
                                        _fromdate =
                                            '${date.year}-${date.month}-${date.day}';
                                        setState(() {
                                          _fromDateInt = date;

                                          if (_toDateInt != null) {
                                            setState(() {
                                              int diffrence = _toDateInt
                                                  .difference(_fromDateInt)
                                                  .inDays;
                                              if (diffrence <= 0)
                                                leavesCount = "Invalid Dates";
                                              else
                                                leavesCount =
                                                    diffrence.toString();
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
                                                        color: dashBoardColor,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 20),
                                  child: RaisedButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    elevation: 4.0,
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          theme: DatePickerTheme(
                                            containerHeight: 250.0,
                                          ),
                                          showTitleActions: true,
                                          minTime: DateTime(2000, 1, 1),
                                          maxTime: DateTime(2022, 12, 31),
                                          onConfirm: (date) {
                                        print('confirm $date');
                                        _todate =
                                            '${date.year}-${date.month}-${date.day}';
                                        setState(() {
                                          _toDateInt = date;

                                          if (_fromDateInt != null) {
                                            setState(() {
                                              int diffrence = _toDateInt
                                                  .difference(_fromDateInt)
                                                  .inDays;
                                              if (diffrence <= 0)
                                                leavesCount = "Invalid Dates";
                                              else
                                                leavesCount =
                                                    diffrence.toString();
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
                                                          color: dashBoardColor,
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
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: Text('Number of days on leave'),
                              ),
                              TextFormField(
                                readOnly: true,
                                enabled: false,
                                
                                decoration: InputDecoration(
                                  labelText: leavesCount,
                                  labelStyle: TextStyle(color: Colors.black54),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black45, width: 1.0),
                                  ),
                                ),
                                onTap: () {},
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
                                onSelected: (List selected) => setState(() {
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
                                decoration: new InputDecoration(
                                  labelText: "Message for Management (Optional)",
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
                                  child: RaisedButton(
                                      color: splashScreenColorTop,
                                      hoverColor: splashScreenColorBottom,
                                      hoverElevation: 40.0,
                                      onPressed: () {
                                        //onLoadingDialog(context);
                                        if(_validateData(context)){
                                          addLeave(context);
                                        }
                                        
                                      },
                                      child: Text('Submit',
                                          style:
                                              TextStyle(color: Colors.white)))),
                                              
                            ]
                          )
                        )
                    )
                  )
                  )
              );
  }

  void addLeave(BuildContext context){

    int request = int.parse(leavesCount);

    _userRef.child(widget.user.uid).child("leaves").child(leaveKeys[leaveIndex]).once().then((DataSnapshot snapshot){

      if(snapshot.value < request){
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Cannot Process Request"),
              content: Text("Not enough leaves present"),
            );
          }
        );
      }
      else
      {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Request sent to Manager"),
              content: Text("You will get a notification once it is approved"),
            );
          }
        );
      }
    
    });

  }
  bool _validateData(BuildContext context) {
    
    bool returnVal = true;
  
    if(leavesCount == "-" || leavesCount == "Invalid Dates"){
      SnackBar error = new SnackBar(content: Text("Please enter valid dates", style: TextStyle(color: Colors.white)),backgroundColor: Colors.red,);
      Scaffold.of(context).showSnackBar(error);
      returnVal = false;
    }

    if(leaveIndex == -1){
       SnackBar error = new SnackBar(content: Text("Please select type of leave", style: TextStyle(color: Colors.white)),backgroundColor: Colors.red,);
      Scaffold.of(context).showSnackBar(error);
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
            new FlatButton(
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
