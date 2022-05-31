import 'package:flutter/material.dart';

class CustomScaffoldMessenger {
  final String? text;
  final bool? isGreen;
  final BuildContext? context;

  CustomScaffoldMessenger.build({this.text, this.isGreen, this.context}){
    ScaffoldMessenger.of(context!).clearSnackBars();
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(text!),
        backgroundColor: isGreen! ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

