import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../widgets/dashboard_tile.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<List> tileData = [
    [
      Icons.record_voice_over,
      "Attendance Recorder",
      "Mark your In and Out Time",
      () {}
    ],
    [
      Icons.record_voice_over,
      "Attendance Summary",
      "Check your previous record",
      () {}
    ],
    [
      Icons.home,
      "Leaves Application/Withdrawal",
      "Management",
      () {}
    ],
    [
      Icons.home,
      "Leaves Status",
      "Check pending status of leaves",
          () {}
    ],
  ];

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
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(21.0),
              child: Icon(
                Icons.equalizer,
                color: Colors.deepPurpleAccent,
                size: 50.0,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 35.0, left: 8.0),
              child: Text(
                'DASHBOARD',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF4D5097),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            flexibleSpace: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    const Color(0xFFFFFFFF),
                    const Color(0xFFFFFFFF),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
            elevation: 10,
          ),
          preferredSize: Size.fromHeight(90.0),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StaggeredGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: _listWidget(),
            staggeredTiles: _staggeredTiles(),
          ),
        ));
  }
}
