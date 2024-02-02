import 'package:flutter/material.dart';
import 'package:insult_me/enum/snackbar_type_enum.dart';
import 'package:insult_me/models/quote.dart';
import 'package:insult_me/services/locator_service.dart';
import 'package:insult_me/widgets/text_input_dialog.dart';

class NewInsultWidget extends StatefulWidget {
  const NewInsultWidget({super.key});

  @override
  State<NewInsultWidget> createState() => _NewInsultWidgetState();
}

class _NewInsultWidgetState extends State<NewInsultWidget> {
  TextEditingController textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        var insult = await showDialog<String>(
            context: context,
            builder: (context) {
              return TextInputDialog(
                textFieldController: textFieldController,
                hint: 'Plant your hilarious seed here...',
                subTitle: "Brew brilliance with your unique wit!",
                title: 'Insult Infusion Center',
              );
            });
        if (insult != null) {
          textFieldController.text = "";
          LocatorService.deviceInfoService.getDeviceId().then(
            (deviceId) {
              LocatorService.firestoreService
                  .addQuote(Quote(
                      id: DateTime.now().millisecondsSinceEpoch,
                      quote: insult,
                      addedDate: DateTime.now(),
                      addedBy: deviceId ?? "nblaurenciana"))
                  .then((isSuccess) async {
                if (isSuccess) {
                  LocatorService.syncService.sync().then((_) {
                    LocatorService.snackbarService.showSnackbar(
                        context, "Successfuly added new insult",
                        type: SnackbarType.success);
                  });
                } else {
                  LocatorService.snackbarService.showSnackbar(
                      context, "Can't process your request this time.",
                      type: SnackbarType.error);
                }
              });
            },
          );
        }
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
      child: const Text(
        'Throw Insult',
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
