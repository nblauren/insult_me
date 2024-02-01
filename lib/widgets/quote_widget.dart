import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:insult_me/models/quote.dart';
import 'package:insult_me/services/database_service.dart';
import 'package:insult_me/services/sync_service.dart';

class QuoteWidget extends StatefulWidget {
  const QuoteWidget({super.key});

  @override
  State<QuoteWidget> createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  Quote? myQuoteToday;
  DatabaseService? databaseService;

  @override
  void initState() {
    super.initState();
    _initialization();
  }

  void _initialization() async {
    databaseService = DatabaseService();
    await _syncQuotes();
    // Get/set my quote today
    _setQuoteToday();
  }

  Future<void> _syncQuotes() async {
    await SyncService().sync();
  }

  void _setQuoteToday() {
    databaseService?.initializeDatabase().then(
          (value) => databaseService?.getMyQuoteToday().then(
            (todayQuote) {
              setState(() {
                myQuoteToday = todayQuote;
              });
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Align(
            alignment: Alignment.centerLeft,
            child: myQuoteToday == null
                ? const CircularProgressIndicator()
                : AutoSizeText(
                    myQuoteToday!.quote,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 50),
                  )),
      ),
    );
  }
}
