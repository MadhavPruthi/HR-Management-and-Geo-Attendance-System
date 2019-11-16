import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_attendance_system/src/models/office.dart';
import 'package:geo_attendance_system/src/services/attendance_mark.dart';
import 'package:geo_attendance_system/src/services/fetch_offices.dart';
import 'package:geo_attendance_system/src/ui/widgets/loader_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AttendanceRecorderWidget extends StatefulWidget {
  @override
  AttendanceRecorderWidgetState createState() =>
      AttendanceRecorderWidgetState();
}

class AttendanceRecorderWidgetState extends State<AttendanceRecorderWidget> {
  Completer<GoogleMapController> _controller = Completer();

  double zoomVal = 5.0;
  OfficeDatabase officeDatabase = new OfficeDatabase();

  // ignore: unused_field
  StreamSubscription<LocationData> _locationSubscription;
  LocationData _currentLocation;
  LocationData _startLocation;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  Location _locationService = new Location();
  bool _permission = false;
  String error;
  CameraPosition _currentCameraPosition;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_locationSubscription != null) _locationSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          googleMap(context),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(100.0)),
              child: Icon(
                Icons.arrow_back,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          buildContainer(context),
        ],
      ),
    );
  }

  Widget googleMap(BuildContext context) {
    double _initialLat = 30.677515;
    double _initialLong = 76.743902;
    double _initialZoom = 15;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        circles: _circles,
        initialCameraPosition: CameraPosition(
            target: LatLng(_initialLat, _initialLong), zoom: _initialZoom),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  buildContainer(BuildContext context) {
    TextStyle textStyle = TextStyle(
        fontSize: 22, color: Colors.blueGrey, fontWeight: FontWeight.w900);
    return Positioned(
      top: 5 * (MediaQuery.of(context).size.height) / 6,
      left: MediaQuery.of(context).size.width / 4,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: <BoxShadow>[
              BoxShadow(offset: Offset(0, 3), blurRadius: 10, spreadRadius: 0.2)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  child: Text(
                    "IN",
                    style: textStyle,
                  ),
                  onPressed: () {
                    onLoadingDialog(context);
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.pop(context);
                      markInAttendance(context, Office(), _currentLocation);
                    });
                  }),
              Text(
                "|",
                style: textStyle,
              ),
              FlatButton(
                child: Text(
                  "OUT",
                  style: textStyle,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, long), zoom: 15, tilt: 50.0, bearing: 45.0)));
  }

  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.BALANCED, interval: 1000);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            _currentCameraPosition = CameraPosition(
                target: LatLng(result.latitude, result.longitude),
                zoom: 16,
                tilt: 50.0,
                bearing: 45.0);

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
                CameraUpdate.newCameraPosition(_currentCameraPosition));
            if (mounted) {
              setState(() {
                _currentLocation = result;
                _markers.clear();
                _markers.add(Marker(
                    markerId: MarkerId("Current Location"),
                    position: LatLng(result.latitude, result.longitude)));
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      _startLocation = location;
    });
  }
}
