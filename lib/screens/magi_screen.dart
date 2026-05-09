import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/eva_theme.dart';
import '../widgets/eva_button.dart';
import '../widgets/eva_clip.dart';
import '../widgets/eva_micro_label.dart';
import '../widgets/eva_pip.dart';

enum _MagiPhase { idle, analyzing, complete }

enum _MagiVerdict { approved, denied }

const _magiUnits = [
  ('MELCHIOR-1', 'NAOKO-R', 'SYS:3.21.0'),
  ('BALTHASAR-2', 'YUIS-M', 'SYS:3.21.0'),
  ('CASPAR-3', 'NAOKO-C', 'SYS:3.21.0'),
];

class MagiScreen extends StatefulWidget {
  const MagiScreen({super.key});

  @override
  State<MagiScreen> createState() => _MagiScreenState();
}

class _MagiScreenState extends State<MagiScreen> {
  _MagiPhase _phase = _MagiPhase.idle;
  final Map<String, _MagiVerdict?> _verdicts = {
    'MELCHIOR-1': null,
    'BALTHASAR-2': null,
    'CASPAR-3': null,
  };
  final _random = Random();
  final _scrollController = ScrollController();
  int _submitCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _MagiVerdict _randomVerdict() =>
      _random.nextBool() ? _MagiVerdict.approved : _MagiVerdict.denied;

  _MagiVerdict _finalVerdict() {
    final approved = _verdicts.values.where((v) => v == _MagiVerdict.approved).length;
    return approved >= 2 ? _MagiVerdict.approved : _MagiVerdict.denied;
  }

  void _submit() {
    if (_phase != _MagiPhase.idle) return;
    setState(() {
      _submitCount++;
      _phase = _MagiPhase.analyzing;
      for (final key in _verdicts.keys) {
        _verdicts[key] = null;
      }
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => _verdicts['MELCHIOR-1'] = _randomVerdict());
    });
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      setState(() => _verdicts['BALTHASAR-2'] = _randomVerdict());
    });
    Future.delayed(const Duration(milliseconds: 4200), () {
      if (!mounted) return;
      setState(() => _verdicts['CASPAR-3'] = _randomVerdict());
    });
    Future.delayed(const Duration(milliseconds: 4800), () {
      if (!mounted) return;
      setState(() => _phase = _MagiPhase.complete);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  void _reset() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _phase = _MagiPhase.idle;
        for (final key in _verdicts.keys) {
          _verdicts[key] = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          EvaButton(
            label: _phase == _MagiPhase.analyzing ? 'ANALIZANDO...' : 'SUBMIT TO MAGI',
            variant: EvaButtonVariant.primary,
            size: EvaButtonSize.lg,
            onPressed: _phase == _MagiPhase.idle ? _submit : null,
          ),
          const SizedBox(height: 24),
          const EvaMicroLabel('[ UNIDADES MAGI ]'),
          const SizedBox(height: 12),
          ..._magiUnits.asMap().entries.map((e) {
            final idx = e.key;
            final (name, system, unitBuild) = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _MagiUnitPanel(
                key: _submitCount > 0 ? ValueKey('$name-$_submitCount') : null,
                name: name,
                system: system,
                buildCode: unitBuild,
                phase: _phase,
                verdict: _verdicts[name],
                entryDelay: idx * 80,
                animate: _submitCount > 0,
              ),
            );
          }),
          if (_phase == _MagiPhase.complete) ...[
            const SizedBox(height: 8),
            _buildFinalVerdict(),
            const SizedBox(height: 16),
            Center(
              child: EvaButton(
                label: 'EJECUTAR DE NUEVO',
                variant: EvaButtonVariant.ghost,
                size: EvaButtonSize.md,
                onPressed: _reset,
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SISTEMA MAGI',
          style: EvaTextStyles.display(size: 36, color: EvaColors.warning),
        ),
        const SizedBox(height: 4),
        Text(
          'PROTOCOLO DE VOTACIÓN — 3 SUPERCOMPUTADORAS',
          style: EvaTextStyles.mono(size: 10, color: EvaColors.textLabel),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05);
  }

  Widget _buildFinalVerdict() {
    final verdict = _finalVerdict();
    final approvedCount = _verdicts.values.where((v) => v == _MagiVerdict.approved).length;
    final isApproved = verdict == _MagiVerdict.approved;
    final verdictColor = isApproved ? EvaColors.statusActive : EvaColors.danger;

    return EvaClipBox(
      cut: 12,
      bottomLeft: true,
      borderColor: verdictColor,
      backgroundColor: verdictColor.withAlpha(15),
      topAccentColor: verdictColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EvaMicroLabel(
              '[ VEREDICTO FINAL — $approvedCount/3 APROBARON ]',
              color: verdictColor,
            ),
            const SizedBox(height: 10),
            Text(
              isApproved ? 'APROBADO' : 'DENEGADO',
              style: EvaTextStyles.display(size: 52, color: verdictColor),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.06, duration: 400.ms);
  }
}

class _MagiUnitPanel extends StatelessWidget {
  final String name;
  final String system;
  final String buildCode;
  final _MagiPhase phase;
  final _MagiVerdict? verdict;
  final int entryDelay;
  final bool animate;

  const _MagiUnitPanel({
    super.key,
    required this.name,
    required this.system,
    required this.buildCode,
    required this.phase,
    required this.verdict,
    required this.entryDelay,
    this.animate = false,
  });

  PipStatus get _pipStatus {
    if (phase == _MagiPhase.idle) return PipStatus.standby;
    if (verdict == null) return PipStatus.danger;
    return verdict == _MagiVerdict.approved ? PipStatus.active : PipStatus.danger;
  }

  bool get _pipPulse => phase == _MagiPhase.analyzing && verdict == null;

  Color get _borderColor {
    if (phase == _MagiPhase.idle) return EvaColors.border;
    if (verdict == null) return EvaColors.warning;
    return verdict == _MagiVerdict.approved ? EvaColors.statusActive : EvaColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final box = EvaClipBox(
      cut: 10,
      borderColor: _borderColor,
      backgroundColor: phase != _MagiPhase.idle
          ? _borderColor.withAlpha(12)
          : EvaColors.surface2,
      topAccentColor: _borderColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                EvaPip(status: _pipStatus, pulse: _pipPulse),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: EvaTextStyles.display(size: 20, color: EvaColors.textValue),
                ),
                const Spacer(),
                Text(
                  system,
                  style: EvaTextStyles.mono(size: 9, color: EvaColors.textLabel),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildStatus(),
            const SizedBox(height: 8),
            Text(
              'BUILD $buildCode',
              style: EvaTextStyles.mono(size: 9, color: EvaColors.textDisabled),
            ),
          ],
        ),
      ),
    );

    if (!animate) return box;
    return box
        .animate()
        .fadeIn(duration: 350.ms, delay: Duration(milliseconds: entryDelay))
        .slideY(begin: 0.03);
  }

  Widget _buildStatus() {
    if (phase == _MagiPhase.idle) {
      return Text(
        'STANDBY',
        style: EvaTextStyles.mono(size: 12, color: EvaColors.statusStandby),
      );
    }

    if (verdict != null) {
      final isApproved = verdict == _MagiVerdict.approved;
      final color = isApproved ? EvaColors.statusActive : EvaColors.danger;
      return Text(
        isApproved ? '▶ APROBADO' : '✕ DENEGADO',
        style: EvaTextStyles.display(size: 26, color: color),
      ).animate().fadeIn(duration: 350.ms).slideX(begin: -0.05);
    }

    return _DotsText(
      text: 'ANALIZANDO',
      style: EvaTextStyles.mono(size: 12, color: EvaColors.warning),
    );
  }
}

class _DotsText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _DotsText({required this.text, required this.style});

  @override
  State<_DotsText> createState() => _DotsTextState();
}

class _DotsTextState extends State<_DotsText> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _dots = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )
      ..addListener(() {
        final next = (_ctrl.value * 4).floor() % 4;
        if (next != _dots) setState(() => _dots = next);
      })
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.text}${'.' * (_dots + 1)}',
      style: widget.style,
    );
  }
}
