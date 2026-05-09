import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/eva_theme.dart';
import 'eva_clip.dart';
import 'eva_icon.dart';
import 'eva_micro_label.dart';
import 'eva_pip.dart';

enum EvaBadgeVariant { status, count, label, outlined, icon }

class EvaBadge extends StatelessWidget {
  final String text;
  final EvaBadgeVariant variant;
  final Color? color;
  final EvaIconName? icon;
  final bool pulse;

  const EvaBadge(
    this.text, {
    super.key,
    this.variant = EvaBadgeVariant.label,
    this.color,
    this.icon,
    this.pulse = false,
  });

  Color get _color => color ?? EvaColors.warning;

  @override
  Widget build(BuildContext context) {
    Widget badge = switch (variant) {
      EvaBadgeVariant.status => _buildStatus(),
      EvaBadgeVariant.count => _buildCount(),
      EvaBadgeVariant.label => _buildLabel(),
      EvaBadgeVariant.outlined => _buildOutlined(),
      EvaBadgeVariant.icon => _buildIconBadge(),
    };

    if (pulse) {
      badge = badge
          .animate(onPlay: (c) => c.repeat())
          .then(delay: 800.ms)
          .fadeOut(duration: 400.ms)
          .then()
          .fadeIn(duration: 400.ms);
    }
    return badge;
  }

  Widget _buildStatus() {
    return ClipPath(
      clipper: const EvaClipper(cut: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.12),
          border: Border.all(color: _color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            EvaPip(
              status: color == EvaColors.danger
                  ? PipStatus.danger
                  : color == EvaColors.statusActive
                      ? PipStatus.active
                      : color == EvaColors.caution
                          ? PipStatus.standby
                          : PipStatus.active,
              pulse: pulse,
            ),
            const SizedBox(width: 6),
            Text(text.toUpperCase(), style: EvaTextStyles.mono(size: 10, color: _color)),
          ],
        ),
      ),
    );
  }

  Widget _buildCount() {
    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _color,
        boxShadow: [BoxShadow(color: _color.withValues(alpha: 0.5), blurRadius: 6)],
      ),
      child: Text(
        text,
        style: EvaTextStyles.mono(size: 10, color: Colors.black, weight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        border: Border(bottom: BorderSide(color: _color, width: 1)),
      ),
      child: Text(
        text.toUpperCase(),
        style: EvaTextStyles.mono(size: 9, color: _color),
      ),
    );
  }

  Widget _buildOutlined() {
    return ClipPath(
      clipper: const EvaClipper(cut: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: _color, width: 1),
        ),
        child: Text(
          text.toUpperCase(),
          style: EvaTextStyles.ui(size: 11, color: _color, weight: FontWeight.w700, letterSpacing: 0.1),
        ),
      ),
    );
  }

  Widget _buildIconBadge() {
    return ClipPath(
      clipper: const EvaClipper(cut: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.1),
          border: Border.all(color: _color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              EvaIcon(icon!, size: 12, color: _color),
              const SizedBox(width: 5),
            ],
            Text(text.toUpperCase(), style: EvaTextStyles.mono(size: 10, color: _color)),
          ],
        ),
      ),
    );
  }
}

class EvaBadgeStack extends StatelessWidget {
  final Widget child;
  final String? count;
  final Color color;

  const EvaBadgeStack({
    super.key,
    required this.child,
    this.count,
    this.color = EvaColors.danger,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count != null)
          Positioned(
            top: -4,
            right: -6,
            child: EvaBadge(count!, variant: EvaBadgeVariant.count, color: color, pulse: true),
          ),
      ],
    );
  }
}

class EvaMicroBadge extends StatelessWidget {
  final String label;
  final Color? color;

  const EvaMicroBadge(this.label, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? EvaColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        border: Border(left: BorderSide(color: c, width: 2)),
      ),
      child: EvaMicroLabel(label, color: c),
    );
  }
}
