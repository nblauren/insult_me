import 'package:flutter/material.dart';

class LocalInsultCountProvider extends ChangeNotifier {
  int quoteCount;

  LocalInsultCountProvider({this.quoteCount = 0});

  void setDailyInsult(int count) async {
    quoteCount = count;
    notifyListeners();
  }
}
