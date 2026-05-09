import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/eva_theme.dart';

enum PipStatus { active, standby, danger, offline }

class EvaPip extends StatelessWidget {
  final PipStatus status;
  final bool pulse;
  final double size;

  const EvaPip({
    super.key,
    this.status = PipStatus.active,
    this.pulse = false,
    this.size = 8,
  });

  Color get _color => switch (status) {
        PipStatus.active => EvaColors.statusActive,
        PipStatus.standby => EvaColors.statusStandby,
        PipStatus.danger => EvaColors.statusDanger,
        PipStatus.offline => EvaColors.statusOffline,
      };

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _color,
        boxShadow: status != PipStatus.offline
            ? [BoxShadow(color: _color.withValues(alpha: 0.7), blurRadius: 6)]
            : null,
      ),
    );

    if (pulse && status != PipStatus.offline && !MediaQuery.disableAnimationsOf(context)) {
      return dot
          .animate(onPlay: (c) => c.repeat())
          .fadeOut(duration: 750.ms, curve: Curves.easeInOut)
          .then()
          .fadeIn(duration: 750.ms, curve: Curves.easeInOut);
    }
    return dot;
  }
}
