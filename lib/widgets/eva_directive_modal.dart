import 'package:flutter/material.dart';
import '../theme/eva_theme.dart';
import 'eva_button.dart';
import 'eva_clip.dart';
import 'eva_icon.dart';
import 'eva_micro_label.dart';
import 'eva_text_input.dart';

enum _Priority { routine, priority, critical }
enum _Subsystem { propulsion, atField, core, shield, sync }

class EvaDirectiveModal extends StatefulWidget {
  final VoidCallback onClose;

  const EvaDirectiveModal({super.key, required this.onClose});

  @override
  State<EvaDirectiveModal> createState() => _EvaDirectiveModalState();
}

class _EvaDirectiveModalState extends State<EvaDirectiveModal> {
  final _codeCtrl  = TextEditingController();
  final _notesCtrl = TextEditingController();
  _Priority  _priority  = _Priority.priority;
  _Subsystem _subsystem = _Subsystem.core;
  bool _transmitted = false;

  static const _priorityMeta = {
    _Priority.routine:  (label: 'ROUTINE',  color: EvaColors.textLabel),
    _Priority.priority: (label: 'PRIORITY', color: EvaColors.warning),
    _Priority.critical: (label: 'CRITICAL', color: EvaColors.danger),
  };

  static const _subsystemMeta = {
    _Subsystem.propulsion: (label: 'PROPULSION', value: 68.0,  level: _BarLevel.normal, badge: 'NOMINAL'),
    _Subsystem.atField:    (label: 'AT-FIELD',   value: 87.4,  level: _BarLevel.normal, badge: 'NOMINAL'),
    _Subsystem.core:       (label: 'CORE',        value: 92.0,  level: _BarLevel.haz,    badge: 'HAZARD'),
    _Subsystem.shield:     (label: 'SHIELD',      value: 14.0,  level: _BarLevel.crit,   badge: 'CRITICAL'),
    _Subsystem.sync:       (label: 'SYNC',        value: 41.3,  level: _BarLevel.sync,   badge: 'SYNC'),
  };

  Color get _accent => _priority == _Priority.critical ? EvaColors.danger : EvaColors.warning;

  bool get _canTransmit => _codeCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _codeCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.88),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: _transmitted ? _buildSuccess() : _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return EvaClipBox(
      cut: 14,
      bottomLeft: true,
      backgroundColor: EvaColors.surface,
      borderColor: _accent,
      topAccentColor: _accent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          _div(),
          _buildPriorityRow(),
          _div(),
          _buildCodeSection(),
          _div(),
          _buildSubsystemSection(),
          _div(),
          _buildNotesSection(),
          _div(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
      color: _accent.withValues(alpha: 0.07),
      child: Row(
        children: [
          EvaIcon(EvaIconName.terminal, color: _accent, size: 16),
          const SizedBox(width: 10),
          Text('NEW DIRECTIVE', style: EvaTextStyles.display(size: 20, color: _accent)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              border: Border.all(color: EvaColors.textLabel.withValues(alpha: 0.4)),
            ),
            child: Text(
              'LV-3 CLEARANCE',
              style: EvaTextStyles.mono(size: 9, color: EvaColors.textLabel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityRow() {
    return Container(
      color: EvaColors.surface2,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          EvaMicroLabel('[ PRIORITY ]'),
          const SizedBox(width: 14),
          ..._Priority.values.map((p) {
            final meta = _priorityMeta[p]!;
            final active = p == _priority;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: GestureDetector(
                onTap: () => setState(() => _priority = p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: active ? meta.color.withValues(alpha: 0.13) : Colors.transparent,
                    border: Border.all(
                      color: active ? meta.color : EvaColors.border,
                      width: active ? 1.5 : 1,
                    ),
                    boxShadow: active
                        ? [BoxShadow(color: meta.color.withValues(alpha: 0.22), blurRadius: 10)]
                        : [],
                  ),
                  child: Text(
                    meta.label,
                    style: EvaTextStyles.mono(
                      size: 10,
                      color: active ? meta.color : EvaColors.textLabel,
                      weight: active ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCodeSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: EvaTextInput(
        label: 'DIRECTIVE CODE',
        controller: _codeCtrl,
        placeholder: 'e.g. DIR-4418',
      ),
    );
  }

  Widget _buildSubsystemSection() {
    final meta = _subsystemMeta[_subsystem]!;
    return Container(
      color: EvaColors.surface2,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EvaMicroLabel('[ TARGET SUBSYSTEM ]', color: EvaColors.textSecondary),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _Subsystem.values.map((s) {
              final active = s == _subsystem;
              return GestureDetector(
                onTap: () => setState(() => _subsystem = s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: active ? _accent.withValues(alpha: 0.12) : Colors.transparent,
                    border: Border.all(
                      color: active ? _accent : EvaColors.border,
                      width: active ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    _subsystemMeta[s]!.label,
                    style: EvaTextStyles.mono(
                      size: 10,
                      color: active ? _accent : EvaColors.textLabel,
                      weight: active ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          _buildInlineBar(meta.label, meta.value, meta.level, meta.badge),
        ],
      ),
    );
  }

  Widget _buildInlineBar(String label, double value, _BarLevel level, String badge) {
    final fill  = _barColor(level);
    final glow  = _barGlow(level);
    final pct   = value.clamp(0.0, 100.0) / 100.0;
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: EvaTextStyles.mono(size: 10, color: EvaColors.textLabel)),
        ),
        Expanded(
          child: Container(
            height: 6,
            color: EvaColors.surface3,
            child: FractionallySizedBox(
              widthFactor: pct,
              alignment: Alignment.centerLeft,
              child: level == _BarLevel.haz
                  ? CustomPaint(painter: _HazPainter(), child: const SizedBox.expand())
                  : Container(
                      decoration: BoxDecoration(
                        color: fill,
                        boxShadow: glow != null ? [BoxShadow(color: glow, blurRadius: 6)] : null,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${value.toStringAsFixed(1)}%',
          style: EvaTextStyles.mono(
            size: 10,
            color: level == _BarLevel.crit ? EvaColors.danger : EvaColors.textValue,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: fill ?? EvaColors.border, width: 1)),
          ),
          child: Text(
            badge,
            style: EvaTextStyles.mono(size: 9, color: fill ?? EvaColors.textLabel),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: EvaTextInput(
        label: 'NOTES',
        controller: _notesCtrl,
        placeholder: 'OPTIONAL OPERATOR NOTES',
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          EvaButton(
            label: 'CANCEL',
            variant: EvaButtonVariant.ghost,
            size: EvaButtonSize.sm,
            onPressed: widget.onClose,
          ),
          const SizedBox(width: 8),
          AnimatedOpacity(
            opacity: _canTransmit ? 1.0 : 0.3,
            duration: const Duration(milliseconds: 150),
            child: EvaButton(
              label: 'TRANSMIT',
              variant: _priority == _Priority.critical
                  ? EvaButtonVariant.danger
                  : EvaButtonVariant.primary,
              size: EvaButtonSize.sm,
              icon: EvaIcon(EvaIconName.signal, size: 13, color: Colors.white),
              onPressed: _canTransmit ? () => setState(() => _transmitted = true) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return EvaClipBox(
      cut: 14,
      bottomLeft: true,
      backgroundColor: EvaColors.surface,
      borderColor: EvaColors.statusActive,
      topAccentColor: EvaColors.statusActive,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EvaIcon(EvaIconName.signal, size: 28, color: EvaColors.statusActive),
            const SizedBox(height: 10),
            Text('DIRECTIVE TRANSMITTED', style: EvaTextStyles.display(size: 18, color: EvaColors.statusActive)),
            const SizedBox(height: 6),
            Text(
              '${_codeCtrl.text.trim().toUpperCase()} · ${_subsystemMeta[_subsystem]!.label} · ${_priorityMeta[_priority]!.label}',
              style: EvaTextStyles.mono(size: 10, color: EvaColors.textLabel),
            ),
            const SizedBox(height: 20),
            EvaButton(label: 'CLOSE', variant: EvaButtonVariant.secondary, size: EvaButtonSize.sm, onPressed: widget.onClose),
          ],
        ),
      ),
    );
  }

  Widget _div() => Container(height: 1, color: EvaColors.border);

  Color? _barColor(_BarLevel l) => switch (l) {
    _BarLevel.normal => EvaColors.warning,
    _BarLevel.crit   => EvaColors.danger,
    _BarLevel.haz    => null,
    _BarLevel.sync   => EvaColors.active,
  };

  Color? _barGlow(_BarLevel l) => switch (l) {
    _BarLevel.normal => EvaColors.warning.withValues(alpha: 0.5),
    _BarLevel.crit   => EvaColors.danger.withValues(alpha: 0.6),
    _BarLevel.haz    => null,
    _BarLevel.sync   => EvaColors.active.withValues(alpha: 0.4),
  };
}

enum _BarLevel { normal, crit, haz, sync }

class _HazPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final amber = Paint()..color = const Color(0xFFFFB800);
    final dark  = Paint()..color = const Color(0xFF1A1A00);
    const w = 6.0;
    canvas.drawRect(Offset.zero & size, dark);
    final p = Path();
    var x = -size.height;
    while (x < size.width + size.height) {
      p.reset();
      p.moveTo(x, 0); p.lineTo(x + w, 0);
      p.lineTo(x + w + size.height, size.height);
      p.lineTo(x + size.height, size.height);
      p.close();
      canvas.drawPath(p, amber);
      x += w * 2;
    }
  }
  @override
  bool shouldRepaint(_HazPainter _) => false;
}
