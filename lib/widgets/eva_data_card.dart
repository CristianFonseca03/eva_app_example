import 'package:flutter/material.dart';
import '../theme/eva_theme.dart';
import 'eva_clip.dart';
import 'eva_micro_label.dart';

class EvaDataCard extends StatelessWidget {
  final String category;
  final String label;
  final String? value;
  final String? unit;
  final bool danger;
  final Widget? footer;

  const EvaDataCard({
    super.key,
    required this.category,
    required this.label,
    this.value,
    this.unit,
    this.danger = false,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return EvaClipBox(
      cut: 12,
      backgroundColor: EvaColors.surface2,
      borderColor: EvaColors.border,
      topAccentColor: danger ? EvaColors.danger : EvaColors.warning,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EvaMicroLabel('[ $category ]'),
            const SizedBox(height: 6),
            Text(
              label.toUpperCase(),
              style: EvaTextStyles.ui(size: 11, color: EvaColors.textSecondary, letterSpacing: 0.1),
            ),
            if (value != null) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value!,
                    style: EvaTextStyles.mono(
                      size: 28,
                      color: danger ? EvaColors.danger : EvaColors.textValue,
                      weight: FontWeight.w700,
                    ),
                  ),
                  if (unit != null)
                    Text(
                      unit!,
                      style: EvaTextStyles.mono(size: 18, color: EvaColors.caution),
                    ),
                ],
              ),
            ],
            if (footer != null) ...[
              const SizedBox(height: 10),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      EvaColors.warning.withValues(alpha: 0.3),
                      EvaColors.warning.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
