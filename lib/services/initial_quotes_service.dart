import 'package:insult_me/models/quote.dart';
import 'package:insult_me/services/database_service.dart';
import 'package:insult_me/utils/json_utils.dart';

class InitialQuotesService {
  final DatabaseService databaseService;

  InitialQuotesService({required this.databaseService});

  Future<void> importQuotes() async {
    var insults = await JsonUtils.readJsonFile('assets/data/insults.json');
    for (var map in insults) {
      databaseService.insertQuote(Quote.fromMap(map));
    }
  }
}
