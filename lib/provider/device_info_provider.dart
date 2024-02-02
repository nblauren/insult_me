import 'package:flutter/material.dart';

class DeviceInfoProvider extends ChangeNotifier {
  String? deviceId;

  DeviceInfoProvider({this.deviceId});

  void setDeviceId(String id) async {
    deviceId = id;
    notifyListeners();
  }
}
