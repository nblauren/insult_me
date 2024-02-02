import 'package:insult_me/models/quote.dart';
import 'package:insult_me/services/locator_service.dart';
import 'package:insult_me/utils/json_utils.dart';

class InitialQuotesService {
  Future<void> importQuotes() async {
    var insults = await JsonUtils.readJsonFile('assets/data/insults.json');
    for (var map in insults) {
      LocatorService().databaseService.insertQuote(Quote.fromMap(map));
    }
  }
}
