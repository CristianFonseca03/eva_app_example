import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/eva_theme.dart';

enum EvaIconName {
  chevronDown,
  clock,
  cross,
  grid,
  lock,
  menu,
  plus,
  shield,
  signal,
  target,
  terminal,
  triangleAlert,
}

class EvaIcon extends StatelessWidget {
  final EvaIconName name;
  final double size;
  final Color? color;

  const EvaIcon(this.name, {super.key, this.size = 20, this.color});

  String get _path => switch (name) {
        EvaIconName.chevronDown => 'assets/icons/chevron-down.svg',
        EvaIconName.clock => 'assets/icons/clock.svg',
        EvaIconName.cross => 'assets/icons/cross.svg',
        EvaIconName.grid => 'assets/icons/grid.svg',
        EvaIconName.lock => 'assets/icons/lock.svg',
        EvaIconName.menu => 'assets/icons/menu.svg',
        EvaIconName.plus => 'assets/icons/plus.svg',
        EvaIconName.shield => 'assets/icons/shield.svg',
        EvaIconName.signal => 'assets/icons/signal.svg',
        EvaIconName.target => 'assets/icons/target.svg',
        EvaIconName.terminal => 'assets/icons/terminal.svg',
        EvaIconName.triangleAlert => 'assets/icons/triangle-alert.svg',
      };

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _path,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? EvaColors.warning,
        BlendMode.srcIn,
      ),
    );
  }
}

class EvaLogo extends StatelessWidget {
  final double height;

  const EvaLogo({super.key, this.height = 40});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/logo.svg',
      height: height,
    );
  }
}
