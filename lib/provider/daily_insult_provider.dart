import 'package:flutter/material.dart';
import 'package:insult_me/models/quote.dart';

class DailyInsultProvider extends ChangeNotifier {
  Quote? dailyInsult;

  DailyInsultProvider({this.dailyInsult});

  void setDailyInsult(Quote quote) async {
    dailyInsult = quote;
    notifyListeners();
  }
}
