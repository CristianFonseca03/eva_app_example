import 'package:flutter/material.dart';

class EvaClipper extends CustomClipper<Path> {
  final double cut;
  final bool bottomLeft;

  const EvaClipper({this.cut = 12.0, this.bottomLeft = false});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (bottomLeft) {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width - cut, 0)
        ..lineTo(size.width, cut)
        ..lineTo(size.width, size.height)
        ..lineTo(cut, size.height)
        ..lineTo(0, size.height - cut)
        ..close();
    } else {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width - cut, 0)
        ..lineTo(size.width, cut)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    }
    return path;
  }

  @override
  bool shouldReclip(EvaClipper old) => old.cut != cut || old.bottomLeft != bottomLeft;
}

class EvaClipBox extends StatelessWidget {
  final Widget child;
  final double cut;
  final bool bottomLeft;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderWidth;
  final Color? topAccentColor;

  const EvaClipBox({
    super.key,
    required this.child,
    this.cut = 12.0,
    this.bottomLeft = false,
    this.borderColor,
    this.backgroundColor,
    this.borderWidth = 1.0,
    this.topAccentColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: EvaClipper(cut: cut, bottomLeft: bottomLeft),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            top: BorderSide(
              color: topAccentColor ?? borderColor ?? const Color(0xFF3D1500),
              width: topAccentColor != null ? 2.0 : borderWidth,
            ),
            left: BorderSide(color: borderColor ?? const Color(0xFF3D1500), width: borderWidth),
            right: BorderSide(color: borderColor ?? const Color(0xFF3D1500), width: borderWidth),
            bottom: BorderSide(color: borderColor ?? const Color(0xFF3D1500), width: borderWidth),
          ),
        ),
        child: child,
      ),
    );
  }
}
