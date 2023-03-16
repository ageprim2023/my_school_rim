import 'package:flutter/material.dart';
import 'package:my_school_rim/tools/styles.dart';

class MyIcon extends StatelessWidget {
  final IconData? icon;
  const MyIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: colorThird,
      size: 30,
    );
  }
}
