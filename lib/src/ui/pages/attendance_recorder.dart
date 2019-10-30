import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  double zoomVal = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.accessibility), onPressed: () {}),
        title: Text("Offices"),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: <Widget>[
          googleMap(context),
          buildContainer(),
        ],
      ),
    );
  }

  Widget buildContainer() {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 150.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              SizedBox(width: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: boxes(30.744600, 76.652496, "Office 7"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: boxes(30.744600, 76.652496, "Office 5"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: boxes(30.744600, 76.652496, "Office 1"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: boxes(30.744600, 76.652496, "Office 2"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: boxes(30.744600, 76.652496, "Office 3"),
              ),
            ],
          ),
        ));
  }

  Widget boxes(double lat, double long, String officeName) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular((24.0)),
            shadowColor: Colors.purple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/office1.jpg'),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(officeName),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget googleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(20.5937, 78.9629), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        //markers: {
        //office1Marker
        //},
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, long), zoom: 15, tilt: 50.0, bearing: 45.0)));
  }
}

Marker office1Marker = Marker(
  markerId: MarkerId('office1'),
  position: LatLng(30.744600, 76.652496),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
);
