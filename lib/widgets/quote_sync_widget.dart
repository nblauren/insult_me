import 'package:flutter/material.dart';
import 'package:insult_me/provider/local_insult_count_provider.dart';
import 'package:insult_me/services/locator_service.dart';
import 'package:provider/provider.dart';

class QuoteSyncWidget extends StatefulWidget {
  final int quoteCount;
  const QuoteSyncWidget({super.key, required this.quoteCount});

  @override
  State<QuoteSyncWidget> createState() => _QuoteSyncWidgetState();
}

class _QuoteSyncWidgetState extends State<QuoteSyncWidget> {
  @override
  void initState() {
    super.initState();
    updateQuoteCount(context);
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
          widget.quoteCount.toString(),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 24,
          ),
        ),
        IconButton(
          onPressed: () {
            LocatorService()
                .syncService
                .sync()
                .then((value) => updateQuoteCount(context));
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  void updateQuoteCount(BuildContext context) {
    LocatorService().databaseService.getQuotes().then(
      (quotes) {
        context.read<LocalInsultCountProvider>().setDailyInsult(quotes.length);
      },
    );
  }
}
