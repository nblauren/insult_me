import 'package:flutter/material.dart';

class TextInputDialog extends StatelessWidget {
  final TextEditingController textFieldController;
  final String title;
  final String hint;

  const TextInputDialog(
      {super.key,
      required this.textFieldController,
      required this.title,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: textFieldController,
        maxLines: 8, //or null
        decoration: const InputDecoration.collapsed(
          hintText: "Your insult goes here",
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context, textFieldController.text),
        ),
      ],
    );
  }
}
