import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:insult_me/provider/daily_insult_provider.dart';
import 'package:provider/provider.dart';

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment.centerLeft,
          child: context.watch<DailyInsultProvider>().dailyInsult == null
              ? const CircularProgressIndicator()
              : AutoSizeText(
                  context.watch<DailyInsultProvider>().dailyInsult!.quote,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 50),
                ),
        ),
      ),
    );
  }
}
