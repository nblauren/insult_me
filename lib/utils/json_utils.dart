import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JsonUtils {
  static Future<List> readJsonFile(String filePath) async {
    final String input = await rootBundle.loadString(filePath);
    final map = await json.decode(input);
    return map["insults"];
  }
}
