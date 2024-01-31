import 'package:insult_me/services/database_service.dart';
import 'package:insult_me/services/firestore_service.dart';

class SyncService {
  Future<void> sync() async {
    DatabaseService databaseService = DatabaseService();
    await databaseService.initializeDatabase();

    var localQuotes = await databaseService.getQuotes();
    var localQuotesIds = localQuotes.map((e) => e.id);

    FirestoreService firestoreService = FirestoreService();
    var firestoreQuotes = await firestoreService.getAllQuotes();

    var notInLocalQuotes =
        firestoreQuotes.where((q) => !localQuotesIds.contains(q.id));
    for (var fireBaseQuote in notInLocalQuotes) {
      databaseService.insertQuote(fireBaseQuote);
    }
  }
}
