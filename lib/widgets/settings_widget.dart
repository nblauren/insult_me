import 'package:flutter/material.dart';
import 'package:insult_me/provider/local_insult_count_provider.dart';
import 'package:insult_me/widgets/notification_time_widget.dart';
import 'package:insult_me/widgets/quote_sync_widget.dart';
import 'package:provider/provider.dart';

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
            const Row(
              children: [
                Expanded(
                  child: Text(
                    "Notification time",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                NotificationTimeWidget(),
              ],
            ),
            QuoteSyncWidget(
                quoteCount:
                    context.watch<LocalInsultCountProvider>().quoteCount),
          ],
        ),
      ),
    );
  }
}
