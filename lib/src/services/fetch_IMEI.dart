import 'dart:async';

import 'package:device_id/device_id.dart';
import 'package:flutter/services.dart';

// Singleton Class
class FetchDeviceDetails {
  static final FetchDeviceDetails _singleton =
      new FetchDeviceDetails._internal();
  String deviceID = "Unknown";
  String imei = "Unknown";
  String meid = "Unknown";

  factory FetchDeviceDetails() {
    return _singleton;
  }

  FetchDeviceDetails._internal() {
    fetchDeviceID();
  }

  Future<void> fetchDeviceID() async {
    String _deviceID;
    String _IMEI;
    String _MEID;

    _deviceID = await DeviceId.getID;
    try {
      _IMEI = await DeviceId.getIMEI;
      _MEID = await DeviceId.getMEID;
    } on PlatformException catch (e) {
      print(e.message);
    }

    deviceID = _deviceID;
    imei = _IMEI;
    meid = _MEID;
  }
}
