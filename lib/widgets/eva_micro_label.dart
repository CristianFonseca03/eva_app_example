import 'package:flutter/material.dart';
import '../theme/eva_theme.dart';

class EvaMicroLabel extends StatelessWidget {
  final String text;
  final Color? color;

  const EvaMicroLabel(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: EvaTextStyles.microLabel(color: color),
    );
  }
}
