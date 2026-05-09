import 'package:flutter/material.dart';
import '../theme/eva_theme.dart';
import 'eva_clip.dart';

enum EvaButtonVariant { primary, secondary, danger, ghost, hazard }
enum EvaButtonSize { sm, md, lg }

class EvaButton extends StatefulWidget {
  final String label;
  final EvaButtonVariant variant;
  final EvaButtonSize size;
  final VoidCallback? onPressed;
  final Widget? icon;

  const EvaButton({
    super.key,
    required this.label,
    this.variant = EvaButtonVariant.secondary,
    this.size = EvaButtonSize.md,
    this.onPressed,
    this.icon,
  });

  @override
  State<EvaButton> createState() => _EvaButtonState();
}

class _EvaButtonState extends State<EvaButton> {
  bool _hovered = false;
  bool _pressed = false;

  double get _height => switch (widget.size) {
        EvaButtonSize.sm => 28,
        EvaButtonSize.md => 36,
        EvaButtonSize.lg => 44,
      };

  double get _fontSize => switch (widget.size) {
        EvaButtonSize.sm => 11,
        EvaButtonSize.md => 13,
        EvaButtonSize.lg => 15,
      };

  EdgeInsets get _padding => switch (widget.size) {
        EvaButtonSize.sm => const EdgeInsets.symmetric(horizontal: 12),
        EvaButtonSize.md => const EdgeInsets.symmetric(horizontal: 16),
        EvaButtonSize.lg => const EdgeInsets.symmetric(horizontal: 24),
      };

  double get _cut => switch (widget.size) {
        EvaButtonSize.sm => 6,
        EvaButtonSize.md => 10,
        EvaButtonSize.lg => 12,
      };

  bool get _disabled => widget.onPressed == null;

  @override
  Widget build(BuildContext context) {
    if (widget.variant == EvaButtonVariant.hazard) return _buildHazard();

    final (bgColor, textColor, borderColor, shadows) = switch (widget.variant) {
      EvaButtonVariant.primary => (
          _hovered && !_disabled ? const Color(0xFFFF4040) : EvaColors.danger,
          Colors.white,
          EvaColors.danger,
          [
            BoxShadow(color: EvaColors.danger.withAlpha(_hovered ? 200 : 153), blurRadius: _hovered ? 12 : 8),
            BoxShadow(color: EvaColors.danger.withAlpha(_hovered ? 100 : 76), blurRadius: _hovered ? 28 : 20),
          ]
        ),
      EvaButtonVariant.secondary => (
          _hovered && !_disabled ? EvaColors.warning.withAlpha(20) : Colors.transparent,
          EvaColors.warning,
          _hovered && !_disabled ? EvaColors.caution : EvaColors.warning,
          <BoxShadow>[
            if (_hovered && !_disabled)
              BoxShadow(color: EvaColors.warning.withAlpha(76), blurRadius: 8),
          ],
        ),
      EvaButtonVariant.danger => (
          _hovered && !_disabled ? const Color(0xFF100000) : Colors.black,
          EvaColors.danger,
          EvaColors.danger,
          [
            BoxShadow(color: EvaColors.danger.withAlpha(_hovered ? 100 : 76), blurRadius: 8, spreadRadius: -2),
          ]
        ),
      EvaButtonVariant.ghost => (
          _hovered && !_disabled ? EvaColors.surface2 : Colors.transparent,
          _hovered && !_disabled ? EvaColors.textSecondary : EvaColors.textLabel,
          _hovered && !_disabled ? EvaColors.muted : EvaColors.border,
          <BoxShadow>[],
        ),
      EvaButtonVariant.hazard => (Colors.transparent, Colors.white, Colors.transparent, <BoxShadow>[]),
    };

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() { _hovered = false; _pressed = false; }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) { setState(() => _pressed = false); widget.onPressed?.call(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedOpacity(
          opacity: _disabled ? 0.4 : (_pressed ? 0.7 : 1.0),
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            child: ClipPath(
              clipper: EvaClipper(cut: _cut),
              child: Container(
                height: _height,
                padding: _padding,
                decoration: BoxDecoration(
                  color: bgColor,
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: shadows,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[widget.icon!, const SizedBox(width: 8)],
                    Text(
                      widget.label.toUpperCase(),
                      style: EvaTextStyles.ui(
                        size: _fontSize,
                        color: textColor,
                        letterSpacing: 0.12,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHazard() {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() { _hovered = false; _pressed = false; }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) { setState(() => _pressed = false); widget.onPressed?.call(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedOpacity(
          opacity: _pressed ? 0.75 : 1.0,
          duration: const Duration(milliseconds: 80),
          child: ClipPath(
            clipper: EvaClipper(cut: _cut),
            child: SizedBox(
              height: _height,
              child: CustomPaint(
                painter: _HazardStripePainter(hovered: _hovered),
                child: Container(
                  padding: _padding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[widget.icon!, const SizedBox(width: 8)],
                      Text(
                        widget.label.toUpperCase(),
                        style: EvaTextStyles.ui(
                          size: _fontSize,
                          color: Colors.white,
                          letterSpacing: 0.12,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HazardStripePainter extends CustomPainter {
  final bool hovered;
  const _HazardStripePainter({this.hovered = false});

  @override
  void paint(Canvas canvas, Size size) {
    const stripeWidth = 10.0;
    final amber = Paint()..color = const Color(0xFFFFB800);
    final dark = Paint()..color = const Color(0xFF1A1A00);
    final overlay = Paint()..color = Color.fromARGB(hovered ? 140 : 178, 0, 0, 0);

    canvas.drawRect(Offset.zero & size, dark);

    final path = Path();
    var x = -size.height;
    while (x < size.width + size.height) {
      path.reset();
      path.moveTo(x, 0);
      path.lineTo(x + stripeWidth, 0);
      path.lineTo(x + stripeWidth + size.height, size.height);
      path.lineTo(x + size.height, size.height);
      path.close();
      canvas.drawPath(path, amber);
      x += stripeWidth * 2;
    }

    canvas.drawRect(Offset.zero & size, overlay);
  }

  @override
  bool shouldRepaint(_HazardStripePainter old) => old.hovered != hovered;
}
