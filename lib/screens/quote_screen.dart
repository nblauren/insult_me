import 'package:flutter/material.dart';
import 'package:insult_me/models/quote.dart';
import 'package:insult_me/services/database_service.dart';
import 'package:insult_me/services/firestore_service.dart';
import 'package:insult_me/services/sync_service.dart';
import 'package:insult_me/utils/date_utils.dart';
import 'package:insult_me/widgets/quote_widget.dart';
import 'package:insult_me/widgets/settings_widget.dart';
import 'package:insult_me/widgets/text_input_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  final String routeName = "/";

  Future<void> _syncQuotes() async {
    await SyncService().sync();
  }

  Future<void> _showTimerPicker(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("notificationTime");
    String? notificationTime = prefs.getString("notificationTime");

    if (notificationTime == null) {
      if (context.mounted) {
        TimeOfDay? selectedTime = await showTimePicker(
          helpText: 'Set the time you want to receive an insult.',
          barrierDismissible: false,
          initialTime: TimeOfDay.now(),
          initialEntryMode: TimePickerEntryMode.input,
          context: context,
        );
        selectedTime ??= TimeOfDay.now();

        prefs.setString(
            "notificationTime", DateTimeUtils.timeOfDayToString(selectedTime));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _showTimerPicker(context);
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
              const QuoteWidget(),
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
                      var databaseService = DatabaseService();
                      databaseService.initializeDatabase().then(
                            (value) => databaseService.getMyQuoteToday().then(
                              (todayQuote) async {
                                await Share.share(todayQuote.quote);
                              },
                            ),
                          );
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
