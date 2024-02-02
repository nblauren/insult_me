import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceInfoService {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Future<String?> getDeviceId() async {
    try {
      // For Android and iOS platforms
      if (Platform.isAndroid) {
        final deviceInfo = await deviceInfoPlugin.androidInfo;
        return deviceInfo.id;
      } else if (Platform.isIOS) {
        final deviceInfo = await deviceInfoPlugin.iosInfo;
        return deviceInfo.identifierForVendor;
      }
    } catch (e) {
      debugPrint("Error getting device info: $e");
      return null;
    }
    return null;
  }
}
