import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geo_attendance_system/src/models/user.dart';
import 'package:geo_attendance_system/src/services/fetch_user.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget(
      {Key? key, required this.icon, required this.children})
      : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  _ProfilePageWidgetState createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.headlineMedium!,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                width: 72.0,
                child: Icon(widget.icon, color: themeData.primaryColor),
              ),
              Expanded(child: Column(children: widget.children)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem(
      {Key? key,
      required this.icon,
      required this.lines,
      this.tooltip,
      required this.onPressed})
      : assert(lines.length > 1),
        super(key: key);

  final IconData icon;
  final List<String> lines;
  final String? tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...lines
                      .sublist(0, lines.length - 1)
                      .map<Widget>((String line) => Text(line)),
                  Text(lines.last, style: themeData.textTheme.caption),
                ],
              ),
            ),
            SizedBox(
              width: 72.0,
              child: IconButton(
                icon: Icon(icon),
                color: themeData.primaryColor,
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final User user;

  ProfilePage({required this.user});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;
  UserDatabase userDatabase = new UserDatabase();
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  Employee? employee;

  @override
  void initState() {
    super.initState();
    UserDatabase.getDetailsFromUID(widget.user.uid).then((employee) {
      print(employee);
      setState(() {
        this.employee = employee;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: splashScreenColorTop,
        brightness: Brightness.light,
        platform: Theme.of(context).platform,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        body: employee == null
            ? Container(
                color: dashBoardColor,
                child: Center(
                  child: SpinKitChasingDots(
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: _appBarHeight,
                    pinned: _appBarBehavior == AppBarBehavior.pinned,
                    actions: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: TextButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.resolveWith(
                                (states) =>
                                    EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                              shape: MaterialStateProperty.resolveWith(
                                (states) => const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                (states) => Colors.blue,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.edit),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Change Password".toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {},
                          )),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      title: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent.withOpacity(0.5),
                            boxShadow: [
                              BoxShadow(color: Colors.white30, blurRadius: 10)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10),
                          child: Text(
                            "${employee?.firstName} - ${employee?.employeeID}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.asset(
                            'assets/logo/profile.jpg',
//                            package: 'flutter_gallery_assets',
                            fit: BoxFit.cover,
                            height: _appBarHeight,
                          ),
                          // This gradient ensures that the toolbar icons are distinct
                          // against the background image.
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.0, -1.0),
                                end: Alignment(0.0, -0.4),
                                colors: <Color>[
                                  Color(0x60000000),
                                  Color(0x00000000)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                      AnnotatedRegion<SystemUiOverlayStyle>(
                        value: SystemUiOverlayStyle.dark,
                        child: ProfilePageWidget(
                          icon: Icons.call,
                          children: <Widget>[
                            _ContactItem(
                              icon: Icons.call,
                              onPressed: () {},
                              lines: <String>[
                                employee?.contactNumber ?? '',
                                'Mobile',
                              ],
                            ),
                          ],
                        ),
                      ),
                      ProfilePageWidget(
                        icon: Icons.contact_mail,
                        children: <Widget>[
                          _ContactItem(
                            icon: Icons.email,
                            onPressed: () {},
                            lines: <String>[
                              widget.user.email ?? '',
                              'Personal',
                            ],
                          ),
                        ],
                      ),
                      ProfilePageWidget(
                        icon: Icons.location_on,
                        children: <Widget>[
                          _ContactItem(
                            icon: Icons.map,
                            onPressed: () {},
                            lines: <String>[
                              employee?.residentialAddress ?? '',
                              'Home',
                            ],
                          ),
                        ],
                      ),
                      employee?.designation == null
                          ? Container()
                          : ProfilePageWidget(
                              icon: Icons.description,
                              children: <Widget>[
                                _ContactItem(
                                  icon: Icons.work,
                                  onPressed: () {},
                                  lines: <String>[
                                    employee!.designation,
                                    'Designation',
                                  ],
                                ),
                              ],
                            ),
                    ]),
                  ),
                ],
              ),
      ),
    );
  }
}
