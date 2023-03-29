import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';

import '../tools/styles.dart';

class MyAlertDialog extends StatelessWidget {
  final List<Widget> listBody;
  final VoidCallBack onPressed;
  const MyAlertDialog({
    super.key,
    required this.listBody,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.info),
      content: SingleChildScrollView(
        child: ListBody(
          children: listBody,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onPressed,
          child: Text(
            'نعم',
            style: TextStyle(
              color: colorGreen,
              fontSize: 20,
            ),
          ),
        ),
        TextButton(
          child: Text(
            'لا',
            style: TextStyle(
              color: colorRed,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
