import 'package:flutter/material.dart';

import '../fonctions/fonctions.dart';
import '../tools/styles.dart';

class WhatOperator extends StatelessWidget {
  final String number;

  const WhatOperator({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    String oprerator = phoneNumberOprerator(number);
    Color? color;
    Color? colorIcon;
    IconData icon;
    if (oprerator == 'شنقيتل') {
      color = colorPrimary;
    } else if (oprerator == 'ماتال') {
      color = colorSecondary;
    } else if (oprerator == 'موريتل') {
      color = colorThird;
    } else {
      color = colorRed;
    }
    if (number.length == 8) {
      icon = Icons.check_circle;
      colorIcon = colorGreen;
    } else {
      icon = Icons.highlight_off;
      colorIcon = colorRed;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(oprerator != 'هاتف غير صحيح' ? icon : null, color: colorIcon),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: color),
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              oprerator,
              style: TextStyle(
                fontSize: 12,
                color: oprerator == 'ماتال' ? colorBlack : colorWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
