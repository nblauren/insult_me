import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  final TextEditingController textFieldController;
  final String title;
  final String subTitle;
  final String hint;

  const TextInputDialog(
      {super.key,
      required this.textFieldController,
      required this.title,
      required this.subTitle,
      required this.hint});

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  final _formKey = GlobalKey<FormState>();
  int characterCount = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Column(
          children: [
            Text(widget.title),
            Text(
              widget.subTitle,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        content: TextFormField(
          onChanged: (value) => setState(() {
            characterCount = value.length;
          }),
          controller: widget.textFieldController,
          maxLines: 8,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            } else if (value.length < 50) {
              return 'Text must be at least 50 characters long';
            }
            return null;
          },
          decoration: InputDecoration(
            counterText: characterCount.toString(),
            border: const OutlineInputBorder(),
            fillColor: Colors.white,
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, widget.textFieldController.text);
                }
              }),
        ],
      ),
    );
  }
}
