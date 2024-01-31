import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insult_me/models/quote.dart';
import 'package:insult_me/models/quote_rating.dart';

class FirestoreService {
  final CollectionReference quotesCollection =
      FirebaseFirestore.instance.collection('quotes');

  final CollectionReference ratingsCollection =
      FirebaseFirestore.instance.collection('ratings');

  Future<bool> addQuote(Quote quote) async {
    try {
      await quotesCollection.doc(quote.id.toString()).set(quote.toMap());
      return true; // Return true if successful
    } catch (e) {
      return false; // Return false if there's an error
    }
  }

  Future<Quote?> getQuote(int quoteId) async {
    var quoteDoc = await quotesCollection.doc(quoteId.toString()).get();

    if (quoteDoc.exists) {
      return Quote.fromMap(quoteDoc.data() as Map<String, dynamic>);
    }

    return null;
  }

  Future<List<Quote>> getAllQuotes() async {
    var snapshot = await quotesCollection.get();

    return snapshot.docs.map((doc) {
      return Quote.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<bool> addQuoteRating(QuoteRating rating) async {
    try {
      await ratingsCollection.doc(rating.id.toString()).set(rating.toMap());
      return true; // Return true if successful
    } catch (e) {
      return false; // Return false if there's an error
    }
  }

  Future<double> getAverageRating(int quoteId) async {
    var snapshot =
        await ratingsCollection.where('quoteId', isEqualTo: quoteId).get();

    if (snapshot.docs.isNotEmpty) {
      var totalRating = snapshot.docs
          .map((doc) => doc['rating'] as int)
          .reduce((value, element) => value + element);

      return totalRating / snapshot.docs.length;
    }

    return 0.0;
  }
}
