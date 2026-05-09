import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/eva_theme.dart';
import '../widgets/eva_button.dart';
import '../widgets/eva_micro_label.dart';
import '../widgets/eva_progress_bar.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const EvaMicroLabel('[ OPERATOR PROFILE ]'),
          const SizedBox(height: 12),
          Text(
            'IKARI · S',
            style: EvaTextStyles.display(size: 36, color: EvaColors.warning),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
          const SizedBox(height: 4),
          Text(
            'CLEARANCE · LV-3 · CHN-14B',
            style: EvaTextStyles.mono(size: 11, color: EvaColors.textSecondary),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: EvaColors.border,
          ),
          const SizedBox(height: 20),
          EvaProgressBar(value: 41.3, label: 'SYNC RATIO', level: ProgressLevel.sync, thin: true),
          const SizedBox(height: 12),
          EvaProgressBar(value: 88, label: 'HEALTH'),
          const SizedBox(height: 12),
          EvaProgressBar(value: 67, label: 'MISSION CREDIBILITY'),
          const SizedBox(height: 24),
          _buildStatsPanel().animate().fadeIn(delay: 400.ms, duration: 300.ms),
          const SizedBox(height: 24),
          EvaButton(
            label: 'EXPORT TELEMETRY',
            variant: EvaButtonVariant.secondary,
            size: EvaButtonSize.lg,
          ).animate().fadeIn(delay: 450.ms),
          const SizedBox(height: 10),
          EvaButton(
            label: 'SIGN OUT',
            variant: EvaButtonVariant.danger,
            size: EvaButtonSize.md,
          ).animate().fadeIn(delay: 500.ms),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatsPanel() {
    final stats = [
      ('SORTIES', '047'),
      ('ANGELS', '012'),
      ('SYNC PEAK', '71.8%'),
      ('CLEARANCE', 'LV-3'),
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EvaColors.surface2,
        border: Border.all(color: EvaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EvaMicroLabel('[ MISSION STATISTICS ]'),
          const SizedBox(height: 12),
          ...stats.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s.$1, style: EvaTextStyles.ui(size: 12, color: EvaColors.textSecondary, letterSpacing: 0.08)),
                Text(s.$2, style: EvaTextStyles.mono(size: 14, color: EvaColors.textValue, weight: FontWeight.w700)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
