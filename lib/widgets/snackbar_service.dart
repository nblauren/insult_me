import 'package:flutter/material.dart';
import 'package:insult_me/enum/snackbar_type_enum.dart';

class SnackbarService {
  void showSnackbar(BuildContext context, String message,
      {SnackbarType type = SnackbarType.info}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: _getBackgroundColor(type),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Perform some action when the user clicks the action button
        },
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(top: 16.0),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Color _getBackgroundColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.error:
        return Colors.red;
      case SnackbarType.success:
        return Colors.green;
      default:
        return Colors.blue; // Default to info color
    }
  }
}
