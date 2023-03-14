
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';

Future<void> myShowDialog(BuildContext context, String title,
    {String root = ''}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        icon: const Icon(Icons.access_alarms),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  color: Colors.brown,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'موافق',
              style: TextStyle(
                //fontFamily: 'Amiri',
                color: Colors.green,
                fontSize: 20,
              ),
            ),
            onPressed: () {
              if (root == '') {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, root);
              }
            },
          ),
        ],
      );
    },
  );
}

bool phoneNumberValidator(String value) {
  RegExp regex = RegExp('^([2,3,4])[0-9]{7}');
  return regex.hasMatch(value) && value.length==8;
}

void _success(String message) {
  Map<String, dynamic> payload = new Map<String, dynamic>();
  payload["data"] = "content";
  AlertController.show("", message, TypeAlert.success, payload);
}

String phoneNumberOprerator(String value) {
  RegExp chiguitel = RegExp('^([2])');
  RegExp matel = RegExp('^([3])');
  RegExp mauritel = RegExp('^([4])');
  if (chiguitel.hasMatch(value) && value.length<=8) {
    return 'شنقيتل';
  } else if (matel.hasMatch(value)&& value.length<=8) {
    return 'ماتال';
  } else if (mauritel.hasMatch(value)&& value.length<=8) {
    return 'موريتل';
  } else {
    return 'هاتف غير صحيح';
  }
}
