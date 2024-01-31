import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:insult_me/services/notification_service.dart';
import 'package:insult_me/utils/date_utils.dart';
import 'package:insult_me/widgets/quote_sync_widget.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Settings",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
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
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) => Container(
                        height: 216,
                        padding: const EdgeInsets.only(top: 6.0),
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        color: CupertinoColors.systemBackground
                            .resolveFrom(context),
                        child: SafeArea(
                          top: false,
                          child: CupertinoDatePicker(
                            initialDateTime: DateTime.now().add(
                              const Duration(minutes: 2),
                            ),
                            mode: CupertinoDatePickerMode.time,
                            use24hFormat: false,
                            onDateTimeChanged: (DateTime newTime) async {
                              await NotificationService().scheduleNotification(
                                1,
                                "Daily Insult",
                                "A new insult has been uttered.",
                                TimeOfDay.fromDateTime(newTime),
                                DateTimeComponents.time,
                              );
                            },
                          ),
                        ),
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
            const QuoteSyncWidget(),
          ],
        ),
      ),
    );
  }
}
