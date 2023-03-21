import 'package:flutter/material.dart';
import 'package:my_school_rim/tools/styles.dart';

class MyIcon extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final double size;
  const MyIcon({
    super.key,
    required this.icon,
    this.color = Colors.amber,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color == Colors.amber ? colorThird : color,
      size: size,
    );
  }
}
