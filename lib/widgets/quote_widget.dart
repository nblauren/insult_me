import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class QuoteWidget extends StatelessWidget {
  final String quote;
  const QuoteWidget({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment.centerLeft,
          child: AutoSizeText(
            quote,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }
}
