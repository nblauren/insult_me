import 'package:flutter/material.dart';
import 'package:insult_me/enum/snackbar_type_enum.dart';
import 'package:insult_me/models/quote.dart';
import 'package:insult_me/provider/daily_insult_provider.dart';
import 'package:insult_me/services/locator_service.dart';
import 'package:insult_me/utils/date_utils.dart';
import 'package:insult_me/widgets/quote_widget.dart';
import 'package:insult_me/widgets/settings_widget.dart';
import 'package:insult_me/widgets/snackbar_service.dart';
import 'package:insult_me/widgets/text_input_dialog.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  final String routeName = "/";

  Future<void> _setQuoteToday(BuildContext context) async {
    LocatorService.databaseService.getMyQuoteToday().then(
      (todayQuote) {
        context.read<DailyInsultProvider>().setDailyInsult(todayQuote);
      },
    );
  }

  Future<void> _showTimerPicker(BuildContext context) async {
    String? notificationTime =
        await LocatorService.sharedPreferenceHelper.notificationTime;

    if (notificationTime == null) {
      if (context.mounted) {
        LocatorService.notificationService.requestPermissions().then(
          (_) async {
            TimeOfDay? selectedTime = await showTimePicker(
              helpText: 'Set the time you want to receive an insult.',
              barrierDismissible: false,
              initialTime: TimeOfDay.now(),
              initialEntryMode: TimePickerEntryMode.input,
              context: context,
            );
            selectedTime ??= TimeOfDay.now();

            await LocatorService.sharedPreferenceHelper.saveNotificationTime(
                DateTimeUtils.timeOfDayToString(selectedTime));

            LocatorService.notificationService.scheduleNotification(
              selectedTime,
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FutureBuilder(
              future: Future.wait([
                _setQuoteToday(context),
                _showTimerPicker(context),
              ]),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            '"',
                            textAlign: TextAlign.left,
                            textScaler: TextScaler.linear(5),
                          ),
                          Spacer(),
                        ],
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
                                    height: MediaQuery.of(context).size.height *
                                        0.75,
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
                              LocatorService.databaseService
                                  .getMyQuoteToday()
                                  .then(
                                (todayQuote) async {
                                  await Share.share(
                                    todayQuote.quote,
                                    sharePositionOrigin: Rect.fromLTWH(
                                        0,
                                        0,
                                        MediaQuery.of(context).size.width,
                                        MediaQuery.of(context).size.height / 2),
                                  );
                                },
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
                                LocatorService.deviceInfoService
                                    .getDeviceId()
                                    .then(
                                  (deviceId) {
                                    LocatorService.firestoreService
                                        .addQuote(Quote(
                                            id: DateTime.now()
                                                .millisecondsSinceEpoch,
                                            quote: insult,
                                            addedDate: DateTime.now(),
                                            addedBy:
                                                deviceId ?? "nblaurenciana"))
                                        .then((isSuccess) async {
                                      if (isSuccess) {
                                        LocatorService.syncService
                                            .sync()
                                            .then((_) {
                                          LocatorService.snackbarService
                                              .showSnackbar(context,
                                                  "Successfuly added new insult",
                                                  type: SnackbarType.success);
                                        });
                                      } else {
                                        LocatorService.snackbarService.showSnackbar(
                                            context,
                                            "Can't process your request this time.",
                                            type: SnackbarType.error);
                                      }
                                    });
                                  },
                                );
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
                  );
                }
              },
            )),
      ),
    );
  }
}
