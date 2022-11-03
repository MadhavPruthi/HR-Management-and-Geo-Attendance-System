import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';
import 'package:flutter/services.dart';

Future<List<String>> getDeviceDetails() async {
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  final _androidIdPlugin = AndroidId();

  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
      deviceVersion = build.version.toString();
      //UUID for Android
      try {
        identifier = await _androidIdPlugin.getId() ?? 'Unknown ID';
      } on PlatformException {
        identifier = 'Failed to get Android ID.';
      }
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name ?? '';
      deviceVersion = data.systemVersion ?? '';
      identifier = data.identifierForVendor ?? ''; //UUID for iOS
    }
  } on PlatformException {
    print('Failed to get platform version');
  }

//if (!mounted) return;
  return [deviceName, deviceVersion, identifier];
}
