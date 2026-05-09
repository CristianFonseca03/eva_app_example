import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/eva_theme.dart';
import '../widgets/eva_data_card.dart';
import '../widgets/eva_directive_modal.dart';
import '../widgets/eva_micro_label.dart';
import '../widgets/eva_pip.dart';
import '../widgets/eva_progress_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _secondsLeft = 107;
  late Timer _timer;
  OverlayEntry? _directiveOverlay;

  final _logEntries = [
    ('12:45:30', 'INF', EvaColors.warning, 'AT field engaged · CHN-14B'),
    ('12:45:24', 'WRN', EvaColors.caution, 'Sync drift +0.4%'),
    ('12:44:51', 'ERR', EvaColors.danger, 'CHN-09 timeout · retrying'),
    ('12:44:30', 'INF', EvaColors.warning, 'Pilot harness locked'),
    ('12:43:12', 'INF', EvaColors.warning, 'AT field nominal · MAGI sync'),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _secondsLeft = (_secondsLeft - 1).clamp(0, 999));
    });
  }

  void _showDirectiveModal() {
    _directiveOverlay = OverlayEntry(
      builder: (_) => Material(
        color: Colors.transparent,
        child: EvaDirectiveModal(
          onClose: _closeDirectiveModal,
        ).animate().fadeIn(duration: 150.ms),
      ),
    );
    Overlay.of(context).insert(_directiveOverlay!);
  }

  void _closeDirectiveModal() {
    _directiveOverlay?.remove();
    _directiveOverlay = null;
  }

  @override
  void dispose() {
    _directiveOverlay?.remove();
    _timer.cancel();
    super.dispose();
  }

  String get _clockDisplay {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '00:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          EvaDataCard(
            category: 'MISSION CLOCK',
            label: 'T-MINUS',
            value: _clockDisplay,
            danger: true,
            footer: Row(
              children: [
                EvaPip(status: PipStatus.danger, pulse: true),
                const SizedBox(width: 6),
                EvaMicroLabel('ENGAGEMENT WINDOW', color: EvaColors.danger),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: EvaDataCard(category: 'SYNC RATIO', label: 'IKARI · S', value: '41.3', unit: '%'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: EvaDataCard(category: 'AT FIELD', label: 'STRENGTH', value: '87.4', unit: '%'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildSubsystemPanel(),
          const SizedBox(height: 10),
          _buildEventLog(),
              const SizedBox(height: 96),
            ],
          ),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: _buildFab(),
        ),
      ],
    );
  }

  Widget _buildFab() {
    return ClipPath(
      clipper: const _FabClipper(),
      child: Material(
        color: EvaColors.danger,
        child: InkWell(
          onTap: _showDirectiveModal,
          splashColor: Colors.white24,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: EvaColors.danger.withAlpha(153), blurRadius: 12),
                BoxShadow(color: EvaColors.danger.withAlpha(76), blurRadius: 28),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  'NEW DIRECTIVE',
                  style: EvaTextStyles.ui(size: 13, color: Colors.white, weight: FontWeight.w700, letterSpacing: 0.12),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate()
        .fadeIn(delay: 500.ms, duration: 300.ms)
        .slideY(begin: 0.3, delay: 500.ms, duration: 300.ms, curve: Curves.easeOut);
  }

  Widget _buildSubsystemPanel() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EvaColors.surface2,
        border: Border(
          top: const BorderSide(color: EvaColors.warning, width: 2),
          left: BorderSide(color: EvaColors.border),
          right: BorderSide(color: EvaColors.border),
          bottom: BorderSide(color: EvaColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EvaMicroLabel('[ SUBSYSTEM INTEGRITY ]'),
          const SizedBox(height: 12),
          EvaProgressBar(value: 68, label: 'FUEL · OXIDIZER'),
          const SizedBox(height: 10),
          EvaProgressBar(value: 92, label: 'CORE · 92% HAZARD', level: ProgressLevel.haz),
          const SizedBox(height: 10),
          EvaProgressBar(value: 14, label: 'SHIELD · CRITICAL', level: ProgressLevel.crit),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.05);
  }

  Widget _buildEventLog() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EvaColors.surface2,
        border: Border.all(color: EvaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EvaMicroLabel('[ EVENT LOG ]'),
          const SizedBox(height: 8),
          ..._logEntries.map((e) {
            final (time, code, color, msg) = e;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: EvaColors.warning.withValues(alpha: 0.08)),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 68,
                    child: Text(time, style: EvaTextStyles.mono(size: 11, color: EvaColors.textLabel)),
                  ),
                  SizedBox(
                    width: 32,
                    child: Text(code, style: EvaTextStyles.mono(size: 11, color: color, weight: FontWeight.w700)),
                  ),
                  Expanded(
                    child: Text(msg, style: EvaTextStyles.mono(size: 11, color: color)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 350.ms, duration: 400.ms);
  }
}

class _FabClipper extends CustomClipper<Path> {
  const _FabClipper();
  @override
  Path getClip(Size size) => Path()
    ..lineTo(size.width - 12, 0)
    ..lineTo(size.width, 12)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();
  @override
  bool shouldReclip(_FabClipper old) => false;
}
