import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geo_attendance_system/src/services/fetch_IMEI.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
import 'package:geo_attendance_system/src/ui/pages/homepage.dart';
import 'package:geo_attendance_system/src/ui/widgets/Info_dialog_box.dart';
import 'package:geo_attendance_system/src/ui/widgets/loader_dialog.dart';

import '../../services/authentication.dart';

class Login extends StatefulWidget {
  Login({this.auth});

  final BaseAuth auth;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = new GlobalKey<FormState>();
  FirebaseDatabase db = new FirebaseDatabase();
  DatabaseReference _empIdRef, _userRef;

  String _username;
  String _password;
  String _errorMessage = "";
  FirebaseUser _user;
  bool formSubmit = false;
  Auth authObject;

  @override
  void initState() {
    _userRef = db.reference().child("users");
    _empIdRef = db.reference().child('EmployeeID');
    authObject = new Auth();

    super.initState();
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _errorMessage = "";
      });
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      FocusScope.of(context).unfocus();
      onLoadingDialog(context);
      String email;
      try {
        _empIdRef.child(_username).once().then((DataSnapshot snapshot) {
          if (snapshot == null) {
            print("popped");
            _errorMessage = "Invalid Login Details";
          } else {
            email = snapshot.value;
          }
          loginUser(email);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<List> checkForSingleSignOn(FirebaseUser _user) async {
    DataSnapshot dataSnapshot = await _userRef.child(_user.uid).once();

    if (dataSnapshot != null) {
      var uuid = dataSnapshot.value["UUID"];
      List listOfDetails = await getDeviceDetails();

      if (uuid != null) {
        if (listOfDetails[2] == uuid)
          return List.from([true, listOfDetails[2], true]);
        else
          return List.from([false, listOfDetails[2], true]);
      }
      return List.from([true, listOfDetails[2], false]);
    }
    return List.from([false, null, false]);
  }

  void loginUser(String email) async {
    if (email != null) {
      try {
        _user = await authObject.signIn(email, _password);

        checkForSingleSignOn(_user).then((list) {
          Navigator.of(context).pop();

          // Adding UUID to database

          if (list[0] == true && list[2] == false) {
            _userRef.child(_user.uid).update({"UUID": list[1]});
          }

          if (list[0] == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(user: _user)),
            );
          } else {
            showDialogTemplate(
                context,
                "ATTENTION!",
                "\nUnauthorized Access Detected!\nIf you are a Legit user, Kindly Contact HR Dept for the same",
                "assets/gif/no_entry.gif",
                Color.fromRGBO(170, 160, 160, 1.0),
                "Ok");
          }
        });
      } catch (e) {
        Navigator.of(context).pop();
        print("Error" + e.toString());
        setState(() {
          _errorMessage = e.message.toString();
          _formKey.currentState.reset();
        });
      }
    } else {
      setState(() {
        _errorMessage = "Invalid Login Details";
        _formKey.currentState.reset();
        Navigator.of(context).pop();
      });
    }
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new AssetImage('assets/back.jpg'),
            fit: BoxFit.fill,
          ),
//          gradient: LinearGradient(
//            colors: <Color>[Colors.white, Colors.grey[350]],
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            /* Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Image.asset("assets/image_01.png"),
                ),
                Expanded(
                  child: Container(),
                ),
                Image.asset("assets/image_02.png")
              ],
            ),*/
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          "assets/logo/logo.png",
                          width: ScreenUtil.getInstance().setWidth(220),
                          height: ScreenUtil.getInstance().setHeight(220),
                        ),
                        SizedBox(
                          width: ScreenUtil.getInstance().setWidth(40),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("GeoFlix",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Bold",
                                      color: appbarcolor,
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(90),
                                      letterSpacing: .6,
                                      fontWeight: FontWeight.bold)),
                              Text("Geo-Attendance and HR Management System",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Bold",
                                      color: Colors.black54,
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(25),
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(90),
                    ),
                    formCard(),
                    SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        /*Row(
                          children: <Widget>[
                            SizedBox(
                              width: 12.0,
                            ),
                            GestureDetector(
                              onTap: _radio,
                              child: radioButton(_isSelected),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text("Remember me",
                                style: TextStyle(
                                    fontSize: 12, fontFamily: "Poppins-Medium"))
                          ],
                        ),*/
                        InkWell(
                          child: Container(
                            width: ScreenUtil.getInstance().setWidth(330),
                            height: ScreenUtil.getInstance().setHeight(100),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  splashScreenColorBottom,
                                  Color(0xFF6078ea)
                                ]),
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF6078ea).withOpacity(.3),
                                      offset: Offset(0.0, 8.0),
                                      blurRadius: 8.0)
                                ]),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: validateAndSubmit,
                                child: Center(
                                  child: Text("LOGIN",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins-Bold",
                                          fontSize: 18,
                                          letterSpacing: 1.0)),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        horizontalLine(),
                        Text("Other Options",
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: "Poppins-Medium")),
                        horizontalLine()
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have Login Details? ",
                          style: TextStyle(fontFamily: "Poppins-Medium"),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text("Contact Admin",
                              style: TextStyle(
                                  color: splashScreenColorTop,
                                  fontFamily: "Poppins-Bold")),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget formCard() {
    return new Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Login",
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(45),
                      fontFamily: "Poppins-Bold",
                      letterSpacing: .6)),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Container(
                height: 60,
                child: TextFormField(
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dashBoardColor),
                      ),
                      icon: Icon(
                        Icons.person,
                        color: dashBoardColor,
                      ),
                      hintText: "Employee ID",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0)),
                  validator: (value) =>
                      value.isEmpty ? 'Username can\'t be empty' : null,
                  onSaved: (value) => _username = value.trim(),
                ),
              ),
              Container(
                height: 60,
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dashBoardColor),
                      ),
                      icon: Icon(
                        Icons.lock,
                        color: dashBoardColor,
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0)),
                  validator: (value) =>
                      value.isEmpty ? 'Password can\'t be empty' : null,
                  onSaved: (value) => _password = value,
                ),
              ),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => _formKey.currentState.reset(),
                    child: Text(
                      "Reset",
                      style: TextStyle(
                          color: dashBoardColor,
                          fontFamily: "Poppins-Medium",
                          fontSize: ScreenUtil.getInstance().setSp(28)),
                    ),
                  ),
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: dashBoardColor,
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(28)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
