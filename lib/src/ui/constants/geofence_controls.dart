import 'package:geofencing/geofencing.dart';

final List<GeofenceEvent> triggers = <GeofenceEvent>[
  GeofenceEvent.enter,
  GeofenceEvent.dwell,
  GeofenceEvent.exit
];
final AndroidGeofencingSettings androidSettings = AndroidGeofencingSettings(
    initialTrigger: <GeofenceEvent>[
      GeofenceEvent.enter,
      GeofenceEvent.exit,
      GeofenceEvent.dwell
    ],
    loiteringDelay: 60*1000);
