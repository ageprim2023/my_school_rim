import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../tools/styles.dart';

class MyPinPut extends StatelessWidget {
  final TextEditingController? pinController;
  final bool obscureText;
  final int length;
  //final String? Function(String?)? onValidator;
  const MyPinPut(
      {super.key,
      required this.pinController,
      this.obscureText = true,
      //required this.onValidator,
      this.length = 4});

  @override
  Widget build(BuildContext context) {
    //final focusNode = FocusNode();

    final defaultPinTheme = PinTheme(
      width: 35,
      height: 35,
      textStyle: TextStyle(
        fontSize: 14,
        color: colorGreen,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorPrimary!),
      ),
    );

    return Pinput(
      length: length,
      obscureText: obscureText,
      controller: pinController,
      defaultPinTheme: defaultPinTheme,
      //validator: onValidator,
      //focusNode: focusNode,
      // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      // listenForMultipleSmsOnAndroid: true,
      // // onClipboardFound: (value) {
      //   debugPrint('onClipboardFound: $value');
      //   pinController.setText(value);
      // },
      //hapticFeedbackType: HapticFeedbackType.lightImpact,
      // onCompleted: (pin) {
      //   debugPrint('onCompleted: $pin');
      // },
      // onChanged: (value) {
      //   debugPrint('onChanged: $value');
      // },
      // cursor: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     Container(
      //       margin: const EdgeInsets.only(bottom: 9),
      //       width: 22,
      //       height: 1,
      //       //color: colorThird,
      //     ),
      //   ],
      // ),
      // focusedPinTheme: defaultPinTheme.copyWith(
      //   decoration: defaultPinTheme.decoration!.copyWith(
      //     borderRadius: BorderRadius.circular(8),
      //     border: Border.all(color: colorThird!),
      //   ),
      // ),
      // submittedPinTheme: defaultPinTheme.copyWith(
      //   decoration: defaultPinTheme.decoration!.copyWith(
      //     color: fillColor,
      //     borderRadius: BorderRadius.circular(19),
      //     border: Border.all(color: colorThird!),
      //   ),
      // ),
      // errorPinTheme: defaultPinTheme.copyBorderWith(
      //   border: Border.all(color: Colors.redAccent),
      // ),
    );
  }
}
