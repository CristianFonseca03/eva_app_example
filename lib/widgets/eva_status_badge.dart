import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/eva_theme.dart';
import 'eva_pip.dart';
import 'eva_clip.dart';

class EvaStatusBadge extends StatelessWidget {
  final PipStatus status;
  final String label;

  const EvaStatusBadge({super.key, required this.status, required this.label});

  Color get _color => switch (status) {
        PipStatus.active => EvaColors.statusActive,
        PipStatus.standby => EvaColors.statusStandby,
        PipStatus.danger => EvaColors.statusDanger,
        PipStatus.offline => EvaColors.statusOffline,
      };

  @override
  Widget build(BuildContext context) {
    final badge = ClipPath(
      clipper: const EvaClipper(cut: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.12),
          border: Border.all(color: _color, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            EvaPip(status: status, pulse: status == PipStatus.danger),
            const SizedBox(width: 6),
            Text(
              label.toUpperCase(),
              style: EvaTextStyles.mono(size: 10, color: _color),
            ),
          ],
        ),
      ),
    );

    if (status == PipStatus.danger) {
      return badge
          .animate(onPlay: (c) => c.repeat())
          .then(delay: 800.ms)
          .fadeOut(duration: 400.ms, curve: Curves.easeInOut)
          .then()
          .fadeIn(duration: 400.ms, curve: Curves.easeInOut);
    }
    return badge;
  }
}
