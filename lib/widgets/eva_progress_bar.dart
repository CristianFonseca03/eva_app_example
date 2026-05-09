import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/eva_theme.dart';
import 'eva_micro_label.dart';

enum ProgressLevel { normal, crit, haz, sync }

class EvaProgressBar extends StatefulWidget {
  final double value;
  final String? label;
  final ProgressLevel level;
  final bool thin;
  final bool animate;

  const EvaProgressBar({
    super.key,
    required this.value,
    this.label,
    this.level = ProgressLevel.normal,
    this.thin = false,
    this.animate = true,
  });

  @override
  State<EvaProgressBar> createState() => _EvaProgressBarState();
}

class _EvaProgressBarState extends State<EvaProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanCtrl;

  @override
  void initState() {
    super.initState();
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.level == ProgressLevel.crit) {
      _scanCtrl.repeat();
    }
  }

  @override
  void didUpdateWidget(EvaProgressBar old) {
    super.didUpdateWidget(old);
    if (widget.level == ProgressLevel.crit && !_scanCtrl.isAnimating) {
      _scanCtrl.repeat();
    } else if (widget.level != ProgressLevel.crit && _scanCtrl.isAnimating) {
      _scanCtrl.stop();
    }
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    super.dispose();
  }

  Color get _fillColor => switch (widget.level) {
        ProgressLevel.crit => EvaColors.danger,
        ProgressLevel.sync => EvaColors.active,
        ProgressLevel.haz => Colors.transparent,
        ProgressLevel.normal => EvaColors.warning,
      };

  List<BoxShadow> get _glow => switch (widget.level) {
        ProgressLevel.crit => [BoxShadow(color: EvaColors.danger.withValues(alpha: 0.6), blurRadius: 8)],
        ProgressLevel.sync => [BoxShadow(color: EvaColors.active.withValues(alpha: 0.5), blurRadius: 4)],
        ProgressLevel.haz => [],
        ProgressLevel.normal => [BoxShadow(color: EvaColors.warning.withValues(alpha: 0.5), blurRadius: 6)],
      };

  @override
  Widget build(BuildContext context) {
    final clamped = widget.value.clamp(0.0, 100.0) / 100.0;
    final barHeight = widget.thin ? 4.0 : 8.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EvaMicroLabel('[ ${widget.label} ]'),
              Text(
                '${widget.value.round()}%',
                style: EvaTextStyles.mono(
                  size: 11,
                  color: widget.level == ProgressLevel.crit ? EvaColors.danger : EvaColors.textValue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        TweenAnimationBuilder<double>(
          tween: Tween(begin: widget.animate ? 0.0 : clamped, end: clamped),
          duration: widget.animate ? const Duration(milliseconds: 900) : Duration.zero,
          curve: Curves.easeOut,
          builder: (context, progress, _) {
            return Container(
              height: barHeight,
              color: EvaColors.surface3,
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: progress,
                    alignment: Alignment.centerLeft,
                    child: _buildFill(barHeight),
                  ),
                  if (widget.level == ProgressLevel.crit)
                    AnimatedBuilder(
                      animation: _scanCtrl,
                      builder: (context2, _) => Positioned(
                        left: (progress * MediaQuery.of(context).size.width - 3).clamp(0, double.infinity),
                        top: 0,
                        bottom: 0,
                        width: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6 * (1 - _scanCtrl.value)),
                            boxShadow: [
                              BoxShadow(
                                color: EvaColors.danger.withValues(alpha: 0.8),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFill(double height) {
    if (widget.level == ProgressLevel.haz) {
      return SizedBox(
        height: height,
        child: CustomPaint(painter: _HazProgressPainter()),
      );
    }

    Widget fill = Container(
      height: height,
      decoration: BoxDecoration(
        color: _fillColor,
        boxShadow: _glow,
      ),
    );

    if (widget.level == ProgressLevel.crit) {
      fill = fill
          .animate(onPlay: (c) => c.repeat())
          .then(delay: 400.ms)
          .fadeOut(duration: 300.ms, curve: Curves.easeInOut)
          .then()
          .fadeIn(duration: 300.ms, curve: Curves.easeInOut);
    }

    return fill;
  }
}

class _HazProgressPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final amber = Paint()..color = const Color(0xFFFFB800);
    final dark = Paint()..color = const Color(0xFF1A1A00);
    const w = 8.0;
    canvas.drawRect(Offset.zero & size, dark);
    final path = Path();
    var x = -size.height;
    while (x < size.width + size.height) {
      path.reset();
      path.moveTo(x, 0);
      path.lineTo(x + w, 0);
      path.lineTo(x + w + size.height, size.height);
      path.lineTo(x + size.height, size.height);
      path.close();
      canvas.drawPath(path, amber);
      x += w * 2;
    }
  }

  @override
  bool shouldRepaint(_HazProgressPainter _) => false;
}
