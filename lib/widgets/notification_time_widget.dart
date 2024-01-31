import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:insult_me/services/notification_service.dart';
import 'package:insult_me/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationTimeWidget extends StatefulWidget {
  const NotificationTimeWidget({super.key});

  @override
  State<NotificationTimeWidget> createState() => _NotificationTimeWidgetState();
}

class _NotificationTimeWidgetState extends State<NotificationTimeWidget> {
  TimeOfDay? notificationTime;

  Future<TimeOfDay> get _getNotificationTime async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notificationTime = prefs.getString("notificationTime");

    if (notificationTime == null) {
      return TimeOfDay.now();
    } else {
      return DateTimeUtils.stringToTimeOfDay(notificationTime);
    }
  }

  Future<void> _setNotificationTime(TimeOfDay tod) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("notificationTime", DateTimeUtils.timeOfDayToString(tod));
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _getNotificationTime.then(
          (notificationTime) {
            showTimePicker(
              helpText: 'Set the time you want to receive an insult.',
              barrierDismissible: false,
              initialTime: notificationTime,
              initialEntryMode: TimePickerEntryMode.input,
              context: context,
            ).then((selectedTime) {
              if (selectedTime != null) {
                _setNotificationTime(selectedTime).then(
                  (_) {
                    NotificationService()
                        .scheduleNotification(
                          1,
                          "Daily Insult",
                          "A new insult has been uttered.",
                          selectedTime,
                          DateTimeComponents.time,
                        )
                        .then((value) => setState(
                              () {
                                notificationTime = selectedTime;
                              },
                            ));
                  },
                );
              }
            });
          },
        );
      },
      child: FutureBuilder<TimeOfDay>(
          future:
              _getNotificationTime, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<TimeOfDay> snapshot) {
            return Text(
              snapshot.hasData && snapshot.data != null
                  ? DateTimeUtils.timeOfDayToString(snapshot.data!)
                  : "Not set",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 24,
              ),
            );
          }),
    );
  }
}
