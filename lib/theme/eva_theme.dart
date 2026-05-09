import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvaColors {
  static const surface = Color(0xFF0A0A0A);
  static const surface2 = Color(0xFF111111);
  static const surface3 = Color(0xFF1A0800);

  static const danger = Color(0xFFFF2020);
  static const warning = Color(0xFFFF6B00);
  static const caution = Color(0xFFFFB800);
  static const active = Color(0xFFF5C518);

  static const data = Color(0xFFCC4400);
  static const muted = Color(0xFF8B4513);
  static const border = Color(0xFF3D1500);

  static const textPrimary = Color(0xFFFF6B00);
  static const textSecondary = Color(0xFFCC4400);
  static const textLabel = Color(0xFF999999);
  static const textValue = Color(0xFFFFFFFF);
  static const textDisabled = Color(0xFF333333);

  static const statusActive = Color(0xFF6BFF3B);
  static const statusStandby = Color(0xFFFFB800);
  static const statusDanger = Color(0xFFFF2020);
  static const statusOffline = Color(0xFF555555);

  static Color glowDanger = const Color(0xFFFF2020).withValues(alpha: 0.4);
  static Color glowWarning = const Color(0xFFFF6B00).withValues(alpha: 0.35);
  static Color glowActive = const Color(0xFFF5C518).withValues(alpha: 0.3);
}

class EvaTextStyles {
  static TextStyle mono({double size = 13, Color? color, FontWeight? weight}) =>
      GoogleFonts.shareTechMono(
        fontSize: size,
        color: color ?? EvaColors.textPrimary,
        fontWeight: weight ?? FontWeight.w400,
        letterSpacing: 0.02,
      );

  static TextStyle display({double size = 40, Color? color}) =>
      GoogleFonts.bebasNeue(
        fontSize: size,
        color: color ?? EvaColors.textPrimary,
        letterSpacing: size > 20 ? 0.14 : 0.08,
      );

  static TextStyle ui({
    double size = 13,
    Color? color,
    FontWeight? weight,
    double? letterSpacing,
  }) => GoogleFonts.rajdhani(
    fontSize: size,
    color: color ?? EvaColors.textPrimary,
    fontWeight: weight ?? FontWeight.w600,
    letterSpacing: letterSpacing ?? 0.08,
  );

  static TextStyle microLabel({Color? color}) => GoogleFonts.shareTechMono(
    fontSize: 11,
    color: color ?? EvaColors.textLabel,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.14,
  );
}

class EvaSpacing {
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s8 = 32;
  static const double s10 = 40;
  static const double s12 = 48;
}

class EvaTheme {
  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: EvaColors.surface,
    colorScheme: const ColorScheme.dark(
      surface: EvaColors.surface,
      primary: EvaColors.warning,
      secondary: EvaColors.caution,
      error: EvaColors.danger,
    ),
    textTheme: GoogleFonts.rajdhaniTextTheme(
      ThemeData.dark().textTheme.apply(bodyColor: EvaColors.textPrimary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: EvaColors.surface,
      elevation: 0,
      titleTextStyle: EvaTextStyles.display(size: 24),
      iconTheme: const IconThemeData(color: EvaColors.warning),
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: EvaColors.surface,
      indicatorColor: EvaColors.warning.withValues(alpha: 0.15),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final active = states.contains(WidgetState.selected);
        return EvaTextStyles.mono(
          size: 9,
          color: active ? EvaColors.warning : Colors.transparent,
        );
      }),
    ),
    dividerColor: EvaColors.border,
    useMaterial3: true,
  );
}
