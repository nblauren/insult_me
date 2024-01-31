import 'package:flutter/material.dart';
import 'package:insult_me/services/database_service.dart';
import 'package:insult_me/services/sync_service.dart';

class QuoteSyncWidget extends StatefulWidget {
  const QuoteSyncWidget({super.key});

  @override
  State<QuoteSyncWidget> createState() => _QuoteSyncWidgetState();
}

class _QuoteSyncWidgetState extends State<QuoteSyncWidget> {
  int quoteCount = 0;

  @override
  void initState() {
    super.initState();
    updateQuoteCount();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            "Sync Quotes",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        Text(
          quoteCount.toString(),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 24,
          ),
        ),
        IconButton(
          onPressed: () {
            SyncService().sync().then((value) => updateQuoteCount());
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  void updateQuoteCount() {
    var databaseService = DatabaseService();
    databaseService.initializeDatabase().then((_) {
      databaseService.getQuotes().then((quotes) {
        setState(() {
          quoteCount = quotes.length;
        });
      });
    });
  }
}
