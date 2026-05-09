import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/eva_theme.dart';
import '../widgets/eva_alert_panel.dart';
import '../widgets/eva_button.dart';
import '../widgets/eva_hazard_modal.dart';
import '../widgets/eva_icon.dart';
import '../widgets/eva_micro_label.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  bool _showModal = false;
  bool _purged = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const EvaAlertPanel(
                level: AlertLevel.danger,
                code: 'ERR-7740 · CORE BREACH',
                message: 'Reactor delta has exceeded safe threshold. Initiate shutdown within 00:01:47.',
              ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.05),
              const SizedBox(height: 12),
              const EvaAlertPanel(
                level: AlertLevel.warn,
                code: 'WRN-2102 · SYNC DRIFT',
                message: 'Pilot sync ratio fluctuating outside nominal band. Recalibrate before next sortie.',
              ).animate().fadeIn(delay: 100.ms, duration: 300.ms).slideX(begin: -0.05),
              const SizedBox(height: 12),
              const EvaAlertPanel(
                level: AlertLevel.warn,
                code: 'WRN-1080 · COOLANT LOOP-B',
                message: 'Auxiliary coolant pressure dropping. Loop-A stable.',
              ).animate().fadeIn(delay: 200.ms, duration: 300.ms).slideX(begin: -0.05),
              const SizedBox(height: 16),
              _buildEmergencyPanel().animate().fadeIn(delay: 350.ms, duration: 400.ms),
              const SizedBox(height: 40),
            ],
          ),
        ),
        if (_showModal)
          EvaHazardModal(
            onClose: () => setState(() => _showModal = false),
            onExecute: () {
              setState(() {
                _showModal = false;
                _purged = true;
              });
            },
          ).animate().fadeIn(duration: 150.ms),
        if (_purged)
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: EvaColors.surface3,
                border: Border.all(color: EvaColors.caution),
              ),
              child: Text(
                'CORE PURGED · MISSION WINDOW EXTENDED BY 70%',
                style: EvaTextStyles.mono(size: 11, color: EvaColors.caution),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn(duration: 300.ms),
          ),
      ],
    );
  }

  Widget _buildEmergencyPanel() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EvaColors.surface2,
        border: Border(
          top: const BorderSide(color: EvaColors.danger, width: 2),
          left: BorderSide(color: EvaColors.border),
          right: BorderSide(color: EvaColors.border),
          bottom: BorderSide(color: EvaColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const EvaMicroLabel('[ EMERGENCY RESPONSE ]'),
          const SizedBox(height: 10),
          Text(
            'Auxiliary core can be purged to recover 70% of remaining mission window.',
            style: EvaTextStyles.ui(size: 13, color: EvaColors.textValue, weight: FontWeight.w400, letterSpacing: 0.04),
          ),
          const SizedBox(height: 4),
          Text(
            'ACTION IS IRREVERSIBLE.',
            style: EvaTextStyles.ui(size: 13, color: EvaColors.danger, weight: FontWeight.w700, letterSpacing: 0.04),
          ),
          const SizedBox(height: 14),
          EvaButton(
            label: 'PURGE CORE',
            variant: EvaButtonVariant.hazard,
            size: EvaButtonSize.lg,
            icon: EvaIcon(EvaIconName.triangleAlert, size: 16, color: Colors.white),
            onPressed: () => setState(() => _showModal = true),
          ),
        ],
      ),
    );
  }
}
