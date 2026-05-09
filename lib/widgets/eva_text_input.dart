import 'package:flutter/material.dart';
import '../theme/eva_theme.dart';
import 'eva_micro_label.dart';

class EvaTextInput extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final String? error;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;

  const EvaTextInput({
    super.key,
    this.label,
    this.placeholder,
    this.error,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
  });

  @override
  State<EvaTextInput> createState() => _EvaTextInputState();
}

class _EvaTextInputState extends State<EvaTextInput> {
  bool _focused = false;

  Color get _accentColor => widget.error != null ? EvaColors.danger : EvaColors.warning;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          EvaMicroLabel('[ ${widget.label} ]', color: EvaColors.textSecondary),
          const SizedBox(height: 4),
        ],
        Focus(
          onFocusChange: (v) => setState(() => _focused = v),
          child: Container(
            decoration: BoxDecoration(
              color: EvaColors.surface2,
              border: Border(
                bottom: BorderSide(color: _accentColor, width: 2),
                left: BorderSide(
                  color: _focused || widget.error != null ? _accentColor : Colors.transparent,
                  width: 3,
                ),
              ),
              boxShadow: _focused
                  ? [BoxShadow(color: _accentColor.withValues(alpha: 0.3), blurRadius: 8)]
                  : [],
            ),
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              obscureText: widget.obscureText,
              style: EvaTextStyles.mono(size: 13, color: EvaColors.warning),
              cursorColor: EvaColors.warning,
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: EvaTextStyles.mono(size: 13, color: EvaColors.textLabel),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        if (widget.error != null) ...[
          const SizedBox(height: 4),
          EvaMicroLabel('ERR · ${widget.error}', color: EvaColors.danger),
        ],
      ],
    );
  }
}
