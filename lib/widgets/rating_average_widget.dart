import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:insult_me/models/quote.dart';
import 'package:insult_me/services/locator_service.dart';

class RatingAverageWidget extends StatefulWidget {
  const RatingAverageWidget({super.key});

  @override
  State<RatingAverageWidget> createState() => _RatingAverageWidgetState();
}

class _RatingAverageWidgetState extends State<RatingAverageWidget> {
  Quote? myQuoteToday;

  @override
  void initState() {
    super.initState();
    _initialization();
  }

  void _initialization() async {
    // Get/set my quote today
    _setQuoteToday();
  }

  void _setQuoteToday() {
    LocatorService().databaseService.getMyQuoteToday().then(
      (todayQuote) {
        setState(() {
          myQuoteToday = todayQuote;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return myQuoteToday == null
        ? Container()
        : FutureBuilder<double>(
            future: LocatorService()
                .firestoreService
                .getAverageRating(myQuoteToday!.id),
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // or some other widget while waiting
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return RatingBar.builder(
                  itemSize: 20,
                  ignoreGestures: snapshot.data == null ? true : false,
                  initialRating: snapshot.data ?? 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.favorite,
                    color: Colors.black26,
                  ),
                  onRatingUpdate: (rating) {},
                );
              }
            },
          );
  }
}
