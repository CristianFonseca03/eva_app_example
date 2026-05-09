import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/eva_theme.dart';
import '../widgets/eva_button.dart';
import '../widgets/eva_clip.dart';
import '../widgets/eva_micro_label.dart';

enum _MagiPhase { idle, analyzing, complete }

enum _MagiVerdict { approved, denied }

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
      _submit();
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
          _buildMagiPanel(),
          const SizedBox(height: 16),
          if (_phase == _MagiPhase.idle)
            EvaButton(
              label: 'SUBMIT TO MAGI',
              variant: EvaButtonVariant.primary,
              size: EvaButtonSize.lg,
              onPressed: _submit,
            ),
          if (_phase == _MagiPhase.complete) ...[
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

  Widget _buildMagiPanel() {
    return EvaClipBox(
      cut: 0,
      borderColor: EvaColors.warning,
      backgroundColor: EvaColors.surface,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = (w * 0.48).clamp(200.0, 360.0);
          final cx = w / 2;
          // Y convergence point: 58% down
          final cy = h * 0.58;
          // Dividers go to interior edge points, not corners
          final tlx = w * 0.27; // top-left divider endpoint
          final trx = w * 0.73; // top-right divider endpoint

          return SizedBox(
            height: h,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MagiPanelPainter(
                      phase: _phase,
                      verdicts: Map.from(_verdicts),
                      cx: cx, cy: cy,
                      tlx: tlx, trx: trx,
                    ),
                  ),
                ),

                // BALTHASAR-2 — top center triangle, centroid ~(cx, cy/3)
                Positioned(
                  top: cy * 0.22,
                  left: w * 0.3,
                  right: w * 0.3,
                  child: _SectionLabel(
                    name: 'BALTHASAR·2',
                    phase: _phase,
                    verdict: _verdicts['BALTHASAR-2'],
                    align: TextAlign.center,
                  ),
                ),

                // CASPAR-3 — left pentagon, centroid ~(w*0.14, h*0.72)
                Positioned(
                  top: cy + (h - cy) * 0.18,
                  left: w * 0.03,
                  width: w * 0.3,
                  child: _SectionLabel(
                    name: 'CASPAR·3',
                    phase: _phase,
                    verdict: _verdicts['CASPAR-3'],
                    align: TextAlign.left,
                  ),
                ),

                // MELCHIOR-1 — right pentagon, centroid ~(w*0.86, h*0.72)
                Positioned(
                  top: cy + (h - cy) * 0.18,
                  right: w * 0.03,
                  width: w * 0.3,
                  child: _SectionLabel(
                    name: 'MELCHIOR·1',
                    phase: _phase,
                    verdict: _verdicts['MELCHIOR-1'],
                    align: TextAlign.right,
                  ),
                ),

                Positioned(
                  left: cx - 56,
                  top: cy - 20,
                  width: 112,
                  child: Container(
                    color: EvaColors.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'MAGI',
                      textAlign: TextAlign.center,
                      style: EvaTextStyles.display(size: 30, color: EvaColors.warning),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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

// ─── Custom painter ────────────────────────────────────────────────────────────

class _MagiPanelPainter extends CustomPainter {
  final _MagiPhase phase;
  final Map<String, _MagiVerdict?> verdicts;
  final double cx, cy, tlx, trx;

  const _MagiPanelPainter({
    required this.phase,
    required this.verdicts,
    required this.cx,
    required this.cy,
    required this.tlx,
    required this.trx,
  });

  // Top center triangle: BALTHASAR
  Path _balthasarPath(Size s) => Path()
    ..moveTo(tlx, 0)
    ..lineTo(trx, 0)
    ..lineTo(cx, cy)
    ..close();

  // Left pentagon: CASPAR  (0,0) → (tlx,0) → center → (cx,h) → (0,h)
  Path _casparPath(Size s) => Path()
    ..moveTo(0, 0)
    ..lineTo(tlx, 0)
    ..lineTo(cx, cy)
    ..lineTo(cx, s.height)
    ..lineTo(0, s.height)
    ..close();

  // Right pentagon: MELCHIOR  (trx,0) → (w,0) → (w,h) → (cx,h) → center
  Path _melchiorPath(Size s) => Path()
    ..moveTo(trx, 0)
    ..lineTo(s.width, 0)
    ..lineTo(s.width, s.height)
    ..lineTo(cx, s.height)
    ..lineTo(cx, cy)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    _paintSection(canvas, size, _balthasarPath(size), verdicts['BALTHASAR-2']);
    _paintSection(canvas, size, _casparPath(size), verdicts['CASPAR-3']);
    _paintSection(canvas, size, _melchiorPath(size), verdicts['MELCHIOR-1']);

    final borderPaint = Paint()
      ..color = EvaColors.warning
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(_balthasarPath(size), borderPaint);
    canvas.drawPath(_casparPath(size), borderPaint);
    canvas.drawPath(_melchiorPath(size), borderPaint);

    const gapW = 22.0;
    final gapPaint = Paint()
      ..color = EvaColors.surface
      ..strokeWidth = gapW
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    final center = Offset(cx, cy);
    canvas.drawLine(center, Offset(tlx, 0), gapPaint);
    canvas.drawLine(center, Offset(trx, 0), gapPaint);
    canvas.drawLine(center, Offset(cx, size.height), gapPaint);

    final accentPaint = Paint()
      ..color = EvaColors.warning
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(center, Offset(tlx, 0), accentPaint);
    canvas.drawLine(center, Offset(trx, 0), accentPaint);
    canvas.drawLine(center, Offset(cx, size.height), accentPaint);
  }

  void _paintSection(Canvas canvas, Size size, Path clip, _MagiVerdict? verdict) {
    canvas.save();
    canvas.clipPath(clip);

    final Color bg;
    final bool stripes;

    if (phase == _MagiPhase.idle) {
      bg = EvaColors.surface2;
      stripes = false;
    } else if (verdict == _MagiVerdict.approved) {
      bg = const Color(0xFF001A00);
      stripes = true;
    } else if (verdict == _MagiVerdict.denied) {
      bg = const Color(0xFF1A0000);
      stripes = false;
    } else {
      bg = const Color(0xFF0D0800);
      stripes = false;
    }

    canvas.drawPaint(Paint()..color = bg);

    if (stripes) {
      final paint = Paint()
        ..color = EvaColors.statusActive.withAlpha(55)
        ..style = PaintingStyle.fill;
      const sw = 22.0;
      var x = -size.height;
      while (x < size.width + size.height) {
        final p = Path()
          ..moveTo(x, 0)
          ..lineTo(x + sw, 0)
          ..lineTo(x + sw + size.height, size.height)
          ..lineTo(x + size.height, size.height)
          ..close();
        canvas.drawPath(p, paint);
        x += sw * 2;
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_MagiPanelPainter old) =>
      old.phase != phase ||
      old.cx != cx || old.cy != cy ||
      old.verdicts['MELCHIOR-1'] != verdicts['MELCHIOR-1'] ||
      old.verdicts['BALTHASAR-2'] != verdicts['BALTHASAR-2'] ||
      old.verdicts['CASPAR-3'] != verdicts['CASPAR-3'];
}

// ─── Section label overlay ─────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String name;
  final _MagiPhase phase;
  final _MagiVerdict? verdict;
  final TextAlign align;

  const _SectionLabel({
    required this.name,
    required this.phase,
    required this.verdict,
    this.align = TextAlign.center,
  });

  Color get _nameColor {
    if (phase == _MagiPhase.idle) return EvaColors.textLabel;
    if (verdict == _MagiVerdict.approved) return EvaColors.statusActive;
    if (verdict == _MagiVerdict.denied) return EvaColors.danger;
    return EvaColors.warning;
  }

  CrossAxisAlignment get _cross => switch (align) {
        TextAlign.left => CrossAxisAlignment.start,
        TextAlign.right => CrossAxisAlignment.end,
        _ => CrossAxisAlignment.center,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: _cross,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          textAlign: align,
          style: EvaTextStyles.display(size: 20, color: _nameColor),
        ),
        const SizedBox(height: 3),
        _buildStatus(),
      ],
    );
  }

  Widget _buildStatus() {
    if (phase == _MagiPhase.idle) {
      return Text(
        'STANDBY',
        textAlign: align,
        style: EvaTextStyles.mono(size: 9, color: EvaColors.textLabel),
      );
    }
    if (verdict == _MagiVerdict.approved) {
      return Text(
        'APROBADO',
        textAlign: align,
        style: EvaTextStyles.mono(size: 9, color: EvaColors.statusActive),
      ).animate().fadeIn(duration: 300.ms);
    }
    if (verdict == _MagiVerdict.denied) {
      return Text(
        'DENEGADO',
        textAlign: align,
        style: EvaTextStyles.mono(size: 9, color: EvaColors.danger),
      ).animate().fadeIn(duration: 300.ms);
    }
    return _DotsText(
      text: 'ANALIZANDO',
      textAlign: align,
      style: EvaTextStyles.mono(size: 9, color: EvaColors.warning),
    );
  }
}

// ─── Animated dots text ────────────────────────────────────────────────────────

class _DotsText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const _DotsText({
    required this.text,
    required this.style,
    this.textAlign = TextAlign.left,
  });

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
      textAlign: widget.textAlign,
      style: widget.style,
    );
  }
}
