import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:insult_me/provider/daily_insult_provider.dart';
import 'package:insult_me/services/locator_service.dart';
import 'package:insult_me/utils/date_utils.dart';
import 'package:insult_me/widgets/new_insult_widget.dart';
import 'package:insult_me/widgets/quote_widget.dart';
import 'package:insult_me/widgets/settings_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  final String routeName = "/";

  Future<void> _setQuoteToday(BuildContext context) async {
    LocatorService.databaseService.getMyQuoteToday().then(
      (todayQuote) async {
        context.read<DailyInsultProvider>().setDailyInsult(todayQuote);
        await HomeWidget.setAppGroupId('group.dev.nikkothe.insultme');
        await HomeWidget.saveWidgetData<String>('insult', todayQuote.quote);
        await HomeWidget.updateWidget(
          name: 'InsultMeWidgetProvider',
          iOSName: 'InsultMeWidget',
        );
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
                          const NewInsultWidget(),
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
