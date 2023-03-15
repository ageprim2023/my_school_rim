import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController textController;
  final String myTitle;
  final bool enabled;
  final String counterText;
  final Function(String) onChange;
  final int maxLength;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool autofocus;
  final Widget prefix;
  final Widget suffix;
  const MyTextField({
    super.key,
    required this.textController,
    required this.myTitle,
    this.enabled = true,
    this.counterText = '',
    required this.onChange,
    this.maxLength = 200,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.autofocus = false,
    this.prefix = const Text(''),
    this.suffix = const Text(''),
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      enabled: enabled,
      onChanged: onChange,
      maxLength: maxLength,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      controller: textController,
      decoration: InputDecoration(
        prefix: prefix,
        suffix: suffix,
        labelText: myTitle,
        counterText: counterText,
      ),
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final Widget prefix;
  final String labelText;
  final Widget suffix;
  final TextEditingController controller;
  final bool enabled;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final Function(String) onChanged;
  final String? Function(String?) onValidator;
  const MyTextFormField({
    super.key,
    required this.labelText,
    required this.controller,
    this.prefix = const Text(''),
    this.suffix = const Text(''),
    this.enabled = true,
    this.keyboardType = TextInputType.name,
    this.obscureText = false,
    this.readOnly = false,
    required this.onChanged,
    required this.onValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6,bottom: 2),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 6),
          prefix: prefix,
          label: Text(labelText),
          suffix: suffix,
        ),
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        readOnly: readOnly,
        validator: onValidator,
      ),
    );
  }
}
