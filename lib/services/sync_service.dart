import 'package:insult_me/services/locator_service.dart';

class SyncService {
  Future<void> sync() async {
    await LocatorService().databaseService.initializeDatabase();

    var localQuotes = await LocatorService().databaseService.getQuotes();
    var localQuotesIds = localQuotes.map((e) => e.id);

    var firestoreQuotes =
        await LocatorService().firestoreService.getAllQuotes();

    var notInLocalQuotes =
        firestoreQuotes.where((q) => !localQuotesIds.contains(q.id));
    for (var fireBaseQuote in notInLocalQuotes) {
      LocatorService().databaseService.insertQuote(fireBaseQuote);
    }
  }
}
