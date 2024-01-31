import 'package:flutter/material.dart';
import 'package:insult_me/models/quote.dart';

class QuoteWidget extends StatelessWidget {
  final Quote? myQuoteToday;

  const QuoteWidget({super.key, required this.myQuoteToday});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment.centerLeft,
          child: myQuoteToday == null
              ? const CircularProgressIndicator()
              : Text(
                  myQuoteToday!.quote,
                  textAlign: TextAlign.left,
                  textScaler: const TextScaler.linear(4),
                ),
        ),
      ),
    );
  }
}
