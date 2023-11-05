import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OutputWidget extends StatelessWidget {
  final ValueListenable<String> text;
  const OutputWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text.value);
  }
}
