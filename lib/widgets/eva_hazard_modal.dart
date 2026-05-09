import 'package:flutter/material.dart';
import '../theme/eva_theme.dart';
import 'eva_button.dart';
import 'eva_clip.dart';
import 'eva_micro_label.dart';
import 'eva_text_input.dart';

class EvaHazardModal extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onExecute;
  final String confirmWord;
  final String actionLabel;
  final String description;

  const EvaHazardModal({
    super.key,
    required this.onClose,
    required this.onExecute,
    this.confirmWord = 'PURGE',
    this.actionLabel = 'PURGE CORE',
    this.description =
        'You are about to PURGE the auxiliary core. This action is irreversible and cannot be undone.',
  });

  @override
  State<EvaHazardModal> createState() => _EvaHazardModalState();
}

class _EvaHazardModalState extends State<EvaHazardModal> {
  final _controller = TextEditingController();
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _confirmed = _controller.text == widget.confirmWord);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: EvaClipBox(
            cut: 12,
            bottomLeft: true,
            backgroundColor: EvaColors.surface,
            borderColor: EvaColors.danger,
            topAccentColor: EvaColors.danger,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  color: EvaColors.danger.withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: EvaColors.danger, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        'CONFIRM IRREVERSIBLE',
                        style: EvaTextStyles.display(size: 18, color: EvaColors.danger),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: EvaColors.border),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.description,
                        style: EvaTextStyles.ui(
                          size: 13,
                          color: EvaColors.textValue,
                          letterSpacing: 0.04,
                          weight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      EvaMicroLabel('[ TYPE "${widget.confirmWord}" ]', color: EvaColors.textSecondary),
                      const SizedBox(height: 6),
                      EvaTextInput(controller: _controller, placeholder: widget.confirmWord),
                    ],
                  ),
                ),
                Container(height: 1, color: EvaColors.border),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      EvaButton(
                        label: 'CANCEL',
                        variant: EvaButtonVariant.secondary,
                        size: EvaButtonSize.sm,
                        onPressed: widget.onClose,
                      ),
                      const SizedBox(width: 8),
                      AnimatedOpacity(
                        opacity: _confirmed ? 1.0 : 0.4,
                        duration: const Duration(milliseconds: 150),
                        child: EvaButton(
                          label: 'EXECUTE',
                          variant: _confirmed ? EvaButtonVariant.hazard : EvaButtonVariant.ghost,
                          size: EvaButtonSize.sm,
                          onPressed: _confirmed ? widget.onExecute : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
