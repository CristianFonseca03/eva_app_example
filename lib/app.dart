import 'package:flutter/material.dart';
import 'theme/eva_theme.dart';
import 'app_shell.dart';

class EvaApp extends StatelessWidget {
  const EvaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EVA-01 Design System',
      debugShowCheckedModeBanner: false,
      theme: EvaTheme.theme,
      home: const AppShell(),
    );
  }
}
