import 'package:flutter/material.dart';

import '../tools/styles.dart';

class MyButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double minWidth;
  final Color color;
  const MyButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.minWidth = 200,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: MaterialButton(
          minWidth: minWidth,
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          )),
    );
  }
}

class MyTextButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const MyTextButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.brown),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
