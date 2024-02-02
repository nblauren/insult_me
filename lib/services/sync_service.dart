import 'package:insult_me/services/database_service.dart';
import 'package:insult_me/services/firestore_service.dart';

class SyncService {
  final DatabaseService databaseService;
  final FirestoreService firestoreService;

  SyncService({required this.firestoreService, required this.databaseService});

  Future<void> sync() async {
    await databaseService.initializeDatabase();

    var localQuotes = await databaseService.getQuotes();
    var localQuotesIds = localQuotes.map((e) => e.id);

    var firestoreQuotes = await firestoreService.getAllQuotes();

    var notInLocalQuotes =
        firestoreQuotes.where((q) => !localQuotesIds.contains(q.id));
    for (var fireBaseQuote in notInLocalQuotes) {
      databaseService.insertQuote(fireBaseQuote);
    }
  }
}
