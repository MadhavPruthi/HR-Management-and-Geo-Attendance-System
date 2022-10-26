import 'dart:isolate';
import 'dart:ui';

import 'package:geo_attendance_system/src/ui/constants/geofence_controls.dart';
import 'package:geo_attendance_system/src/ui/constants/strings.dart';
import 'package:geofencing/geofencing.dart';

ReceivePort port = ReceivePort();

class GeoFenceClass {
  static final GeoFenceClass _singleton = GeoFenceClass._internal();
  static final isolateSpawn =
      IsolateNameServer.registerPortWithName(port.sendPort, geofence_port_name);
  static String geofenceState = 'Unknown';

  GeoFenceClass._internal();

  factory GeoFenceClass() {
    return _singleton;
  }

  static Future<void> startListening(double latitude, double longitude,
      [double radius = radius_geofence]) async {
    await GeofencingManager.registerGeofence(
        GeofenceRegion(fence_id, latitude, longitude, radius, triggers,
            androidSettings: androidSettings),
        callback);
    print(isolateSpawn);

    try {
      port.listen((dynamic data) {
        GeoFenceClass.geofenceState = data;
        print('Event: $data');
      });
    } catch (e) {
      print("Exception Occured: $e");
    }
  }

  static void callback(List<String> ids, Location l, GeofenceEvent e) async {
    print('Fences: $ids Location $l Event: $e');
    final SendPort? send =
        IsolateNameServer.lookupPortByName(geofence_port_name);
    send?.send(e.toString());
  }

  static void closePort() {
    port.close();
  }
}
