import 'package:flutter/material.dart';
import 'package:insult_me/models/quote.dart';
import 'package:insult_me/services/database_service.dart';
import 'package:insult_me/services/firestore_service.dart';
import 'package:insult_me/services/sync_service.dart';
import 'package:insult_me/widgets/quote_widget.dart';
import 'package:insult_me/widgets/settings_widget.dart';
import 'package:insult_me/widgets/text_input_dialog.dart';
import 'package:share_plus/share_plus.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  final String routeName = "/";

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  int quoteCount = 0;
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
    databaseService
        ?.initializeDatabase()
        .then((value) => databaseService?.getMyQuoteToday().then((todayQuote) {
              if (todayQuote == null) {
                databaseService?.insertMyQuoteToday().then((newTodayQuote) {
                  setState(() {
                    myQuoteToday = newTodayQuote;
                  });
                });
              } else {
                setState(() {
                  myQuoteToday = todayQuote;
                });
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '"',
                textAlign: TextAlign.left,
                textScaler: TextScaler.linear(5),
              ),
              QuoteWidget(myQuoteToday: myQuoteToday),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            child: const SettingsWidget(),
                          );
                        },
                      );
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      Share.share(myQuoteToday!.quote);
                    },
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      var insult = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            TextEditingController textFieldController =
                                TextEditingController();
                            return TextInputDialog(
                              textFieldController: textFieldController,
                              hint:
                                  'Type your insult here and make someone cry',
                              title: 'Share insult',
                            );
                          });
                      if (insult != null && insult.length > 5) {
                        FirestoreService()
                            .addQuote(Quote(
                                id: DateTime.now().millisecondsSinceEpoch,
                                quote: insult,
                                addedDate: DateTime.now(),
                                addedBy: "Nikko"))
                            .then((isSuccess) async {
                          if (isSuccess) {
                            _syncQuotes().then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                          "Successfuly added new insult")));
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Can't process your request this time.")));
                          }
                        });
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    child: const Text(
                      'Throw Insult',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
