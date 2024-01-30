import 'package:insult_me/models/quote.dart';
import 'package:insult_me/services/database_service.dart';
import 'package:insult_me/utils/json_utils.dart';

class InitialiseDatabaseService {
  static Future<void> importQuotes() async {
    final DatabaseService databaseService = DatabaseService();
    await databaseService.initializeDatabase();

    var insults = await JsonUtils.readJsonFile('assets/data/insults.json');
    for (var map in insults) {
      databaseService.insertQuote(Quote.fromMap(map));
    }
  }
}
