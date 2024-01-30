import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:insult_me/services/notification_service.dart';
import 'package:insult_me/utils/date_utils.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  final String routeName = "/";

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
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
                textScaler: TextScaler.linear(4),
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Is that your best effort, or did you just start warming up?',
                      textAlign: TextAlign.left,
                      textScaler: TextScaler.linear(4),
                    ),
                  ),
                ),
              ),
              TextButton(
                child: const Text(
                  'tap for more',
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Settings",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Notification time",
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _showDialog(
                                        CupertinoDatePicker(
                                          initialDateTime: DateTime.now()
                                              .add(const Duration(minutes: 2)),
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: false,
                                          onDateTimeChanged:
                                              (DateTime newTime) async {
                                            await NotificationService()
                                                .scheduleNotification(
                                              1,
                                              "Daily Insult",
                                              "A new insult has been uttered.",
                                              TimeOfDay.fromDateTime(newTime),
                                              DateTimeComponents.time,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      DateTimeUtils.formatTime(DateTime.now()),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // This function displays a CupertinoModalPopup with a reasonable fixed height
  // which hosts CupertinoDatePicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
