import 'package:flutter/material.dart';

class ContainerIndicator extends StatelessWidget {
  const ContainerIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black.withOpacity(0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('يرجى الانتظار قليلا'),
          CircularProgressIndicator(
            color: Colors.brown,
          ),
        ],
      ),
    );
  }
}

class ContainerNoIndicator extends StatelessWidget {
  final Widget child;
  const ContainerNoIndicator({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //alignment: Alignment.center,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: child,
        ),
      ),
    );
  }
}
