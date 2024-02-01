import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<String?> getDeviceId() async {
    try {
      // For Android and iOS platforms

      if (DeviceInfoService.isAndroidPlatform()) {
        final deviceInfo = await _deviceInfoPlugin.androidInfo;
        return deviceInfo.id;
      } else if (DeviceInfoService.isIOSPlatform()) {
        final deviceInfo = await _deviceInfoPlugin.iosInfo;
        return deviceInfo.identifierForVendor;
      }
    } catch (e) {
      debugPrint("Error getting device info: $e");
      return null;
    }
    return null;
  }

  static bool isAndroidPlatform() {
    return _deviceInfoPlugin is AndroidDeviceInfo;
  }

  static bool isIOSPlatform() {
    return _deviceInfoPlugin is IosDeviceInfo;
  }
}
