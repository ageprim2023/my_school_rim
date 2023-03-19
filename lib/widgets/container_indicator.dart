import 'package:flutter/material.dart';
import 'package:my_school_rim/tools/styles.dart';

class ContainerIndicator extends StatelessWidget {
  const ContainerIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //const Text('يرجى الانتظار قليلا'),
          CircularProgressIndicator(
            color: colorThird,
          ),
        ],
      ),
    );
  }
}

class ContainerNormal extends StatelessWidget {
  final Widget child;
  const ContainerNormal({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: child,
        ),
      );
  }
}
