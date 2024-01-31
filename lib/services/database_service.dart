import 'package:flutter/material.dart';
import 'package:insult_me/models/my_quote.dart';
import 'package:insult_me/models/quote.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:collection/collection.dart';

class DatabaseService {
  late Database _database;

  DatabaseService() {
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final String path = join(await getDatabasesPath(), 'insult_me_database.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE my_quotes (
            id INTEGER PRIMARY KEY,
            quoteId INTEGER,
            addedDate TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE quotes (
            id INTEGER PRIMARY KEY,
            quote TEXT,
            addedDate TEXT,
            addedBy TEXT
          )
        ''');
      },
    );
  }

  //Quotes
  Future<void> insertQuote(Quote quote) async {
    var id = await _database.insert(
      'quotes',
      quote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('Inserted quote ${id.toString()}');
  }

  Future<List<Quote>> getQuotes() async {
    final List<Map<String, dynamic>> maps = await _database.query('quotes');

    return List.generate(maps.length, (index) {
      return Quote.fromMap(maps[index]);
    });
  }

  Future<Quote> getQuoteById(int id) async {
    List<Quote> quotes = await getQuotes();
    return quotes.where((q) => q.id == id).first;
  }

  Future<Quote> getRandomQuote() async {
    List<Quote> quotes = await getQuotes();
    return quotes.sample(1).single;
  }

  // End of Quotes

  // MyQuote
  Future<void> insertMyQuote(MyQuote myQuote) async {
    await _database.insert(
      'my_quotes',
      myQuote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MyQuote>> getMyQuotes() async {
    final List<Map<String, dynamic>> maps = await _database.query('my_quotes');

    return List.generate(maps.length, (index) {
      return MyQuote.fromMap(maps[index]);
    });
  }

  Future<Quote> getMyQuoteToday() async {
    List<MyQuote> quotes = await getMyQuotes();
    var myQuote = quotes
        .where((q) => DateUtils.isSameDay(q.addedDate, DateTime.now()))
        .firstOrNull;
    if (myQuote == null) {
      return await insertMyQuoteToday();
    } else {
      return await getQuoteById(myQuote.quoteId);
    }
  }

  Future<Quote> insertMyQuoteToday() async {
    Quote quote = await getRandomQuote();
    List<MyQuote> myQuotes = await getMyQuotes();
    bool exists = myQuotes.where((q) => q.quoteId == quote.id).isNotEmpty;
    if (exists) {
      return await insertMyQuoteToday();
    } else {
      var id = DateTime.now().millisecondsSinceEpoch;
      insertMyQuote(
          MyQuote(id: id, quoteId: quote.id, addedDate: DateTime.now()));
      return quote;
    }
  }
  // End of MyQuote

  Future<void> closeDatabase() async {
    await _database.close();
  }
}
