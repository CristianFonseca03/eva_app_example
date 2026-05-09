import 'package:flutter/material.dart';
import '../theme/eva_theme.dart';

enum AlertLevel { danger, warn }

class EvaAlertPanel extends StatelessWidget {
  final AlertLevel level;
  final String code;
  final String message;

  const EvaAlertPanel({
    super.key,
    this.level = AlertLevel.danger,
    required this.code,
    required this.message,
  });

  Color get _color => level == AlertLevel.danger ? EvaColors.danger : EvaColors.warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.06),
        border: Border(left: BorderSide(color: _color, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: _color, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code.toUpperCase(),
                  style: EvaTextStyles.mono(size: 11, color: _color),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: EvaTextStyles.ui(size: 14, color: EvaColors.textValue, letterSpacing: 0.04, weight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
