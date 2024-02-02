import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  // General Methods: ----------------------------------------------------------
  // Auth Token
  Future<String?> get notificationTime async {
    return _sharedPreference.getString("notificationTime");
  }

  Future<bool> saveNotificationTime(String notificationTime) async {
    return _sharedPreference.setString("notificationTime", notificationTime);
  }

  Future<bool> removeNotificationTime() async {
    return _sharedPreference.remove("notificationTime");
  }

  // Refresh Token
  Future<int?> get initScreen async {
    return _sharedPreference.getInt("initScreen");
  }

  Future<bool> saveInitScreen(int initScreen) async {
    return _sharedPreference.setInt("initScreen", initScreen);
  }

  Future<bool> removeInitScreen() async {
    return _sharedPreference.remove("initScreen");
  }
}
