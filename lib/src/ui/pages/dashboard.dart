import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geo_attendance_system/src/services/authentication.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
import 'package:geo_attendance_system/src/ui/constants/dashboard_tile_info.dart';
import 'package:geo_attendance_system/src/ui/pages/pending_approval_manager.dart';
import 'package:geo_attendance_system/src/ui/pages/profile_page.dart';
import 'package:geo_attendance_system/src/ui/widgets/dashboard_tile.dart';

import 'login.dart';

class Dashboard extends StatefulWidget {
  final AnimationController controller;
  final BaseAuth auth;
  final FirebaseUser user;

  Dashboard({this.controller, this.auth, this.user});

  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static const header_height = 100.0;

  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    final backPanelHeight = height - header_height;
    final frontPanelHeight = -header_height;

    return new RelativeRectTween(
            begin: new RelativeRect.fromLTRB(
                0.0, backPanelHeight, 0.0, frontPanelHeight),
            end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(new CurvedAnimation(
            parent: widget.controller, curve: Curves.linear));
  }

  Widget bothPanels(BuildContext context, BoxConstraints constraints) {
    return new Container(
      child: new Stack(
        children: <Widget>[
          new NavigationPanel(
            user: widget.user,
          ),
          new PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: new Material(
              elevation: 12.0,
              borderRadius: new BorderRadius.only(
                  topLeft: new Radius.circular(16.0),
                  topRight: new Radius.circular(16.0)),
              child: new Column(
                children: <Widget>[
                  new Expanded(
                    child: new Center(
                      child: DashboardMainPanel(
                        user: widget.user,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: bothPanels,
    );
  }
}

class DashboardMainPanel extends StatelessWidget {
  final FirebaseUser user;

  DashboardMainPanel({this.user});

  final List tileData = infoAboutTiles;

  List<Widget> _listWidget(BuildContext context) {
    List<Widget> widgets = new List();
    tileData.forEach((tile) {
      widgets.add(buildTile(tile[0], tile[1], tile[2], context, user, tile[3]));
    });

    return widgets;
  }

  List<StaggeredTile> _staggeredTiles() {
    List<StaggeredTile> widgets = new List();
    tileData.forEach((tile) {
      widgets.add(StaggeredTile.extent(1, 210.0));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [splashScreenColorBottom, splashScreenColorTop],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: _listWidget(context),
          staggeredTiles: _staggeredTiles(),
        ),
      ),
    );
  }
}

class NavigationPanel extends StatefulWidget {
  final FirebaseUser user;

  NavigationPanel({this.user});

  @override
  _NavigationPanelState createState() => _NavigationPanelState();
}

class _NavigationPanelState extends State<NavigationPanel> {
  final _databaseReference = FirebaseDatabase.instance.reference();

  Widget drawerTile(String title, Function() onTap, [IconData icon]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: OutlineButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        hoverColor: Colors.transparent,
        borderSide: BorderSide(
          color: Colors.white, //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 0.8, //width of the border
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          leading: Icon(
            icon,
            size: 35,
            color: Colors.white,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: "Poppins-Medium",
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        color: dashBoardColor,
        child: ListView(
          children: <Widget>[
            FutureBuilder(
              future: _databaseReference
                  .child("users")
                  .child(widget.user.uid)
                  .child("allotted_office")
                  .once(),
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
                    return Container();

                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text(
                        'Error:\n\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      );
                      return Stack(children: [
                        drawerTile("Allocated Location: ${snapshot.data.value}",
                            null, Icons.location_on),

                      ]);

                    return Container();
                }
              },
            ),
            FutureBuilder(
              future: _databaseReference
                  .child("users")
                  .child(widget.user.uid)
                  .child("isManager")
                  .once(),
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
                    return Container();

                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text(
                        'Error:\n\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      );
                    print(snapshot.data.value);
                    if (snapshot.data.value == null || snapshot.data.value == 1)
                      return Stack(children: [
                        drawerTile("Review Pending Leaves", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  LeaveApprovalByManagerWidget(
                                    title: "Review Leaves",
                                    user: widget.user,
                                  )));
                        }, Icons.perm_identity),
                        Positioned(
                          child: Icon(
                            Icons.notifications,
                            color: Colors.yellow,
                            size: 30,
                          ),
                          right: 17,
                          height: 40,
                        ),
                      ]);

                    return Container();
                }
              },
            ),
            drawerTile("Edit your Profile", () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(
                        user: widget.user,
                      )));
            }, Icons.perm_identity),
            drawerTile("Logout", () {
              Auth auth = new Auth();
              auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false);
            }, Icons.exit_to_app),
          ],
        ));
  }
}
