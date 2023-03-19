import 'package:flutter/material.dart';
import 'package:my_school_rim/tools/styles.dart';

class MyIcon extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  const MyIcon({
    super.key,
    required this.icon,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color == Colors.amber ? colorThird : color,
      size: 30,
    );
  }
}
