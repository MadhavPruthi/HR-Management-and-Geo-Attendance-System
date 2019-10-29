import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
import 'package:geo_attendance_system/src/ui/constants/dashboard_tile_info.dart';
import 'package:geo_attendance_system/src/ui/widgets/dashboard_tile.dart';

class Dashboard extends StatefulWidget {
  final AnimationController controller;

  Dashboard({this.controller});

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
          new Container(
            color: dashBoardColor,
            child: new Center(
              child: new Text(
                "Navigation Panel",
                style: new TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
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
                      child: DashboardMainPanel(),
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
  final List tileData = infoAboutTiles;

  List<Widget> _listWidget() {
    List<Widget> widgets = new List();
    tileData.forEach((tile) {
      widgets.add(buildTile(tile[0], tile[1], tile[2]));
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: _listWidget(),
        staggeredTiles: _staggeredTiles(),
      ),
    );
  }
}
