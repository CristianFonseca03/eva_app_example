import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/eva_theme.dart';
import '../widgets/eva_button.dart';
import '../widgets/eva_micro_label.dart';
import '../widgets/eva_text_input.dart';

class DirectivesScreen extends StatefulWidget {
  const DirectivesScreen({super.key});

  @override
  State<DirectivesScreen> createState() => _DirectivesScreenState();
}

class _DirectivesScreenState extends State<DirectivesScreen> {
  final _opId = TextEditingController(text: 'IKARI-S-003');
  final _code = TextEditingController();
  String _system = 'PROPULSION';
  bool _cryoLock = false;
  bool _override = false;
  bool _submitted = false;

  final _systems = ['PROPULSION', 'COOLING', 'AT-FIELD', 'CORE', 'MAGI'];

  @override
  void dispose() {
    _opId.dispose();
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _submitted = false);
    });
  }

  void _clear() {
    setState(() {
      _code.clear();
      _system = 'PROPULSION';
      _cryoLock = false;
      _override = false;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const EvaMicroLabel('[ FORM · OPERATOR DIRECTIVE ]'),
          const SizedBox(height: 8),
          Text(
            'Transmit a directive to the active subsystem. All directives are logged and require operator clearance LV-3 or higher.',
            style: EvaTextStyles.ui(size: 13, color: EvaColors.textValue, weight: FontWeight.w400, letterSpacing: 0.04),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 20),
          EvaTextInput(label: 'OPERATOR ID', controller: _opId)
              .animate().fadeIn(delay: 100.ms, duration: 300.ms),
          const SizedBox(height: 16),
          EvaTextInput(
            label: 'DIRECTIVE CODE',
            controller: _code,
            placeholder: 'ENTER CODE',
          ).animate().fadeIn(delay: 150.ms, duration: 300.ms),
          const SizedBox(height: 16),
          _buildSystemSelector().animate().fadeIn(delay: 200.ms, duration: 300.ms),
          const SizedBox(height: 20),
          const EvaMicroLabel('[ INTERLOCKS ]', color: EvaColors.textSecondary),
          const SizedBox(height: 12),
          _CheckRow(
            label: 'CRYO LOCK',
            checked: _cryoLock,
            onToggle: () => setState(() => _cryoLock = !_cryoLock),
          ).animate().fadeIn(delay: 250.ms, duration: 300.ms),
          const SizedBox(height: 12),
          _CheckRow(
            label: 'MANUAL OVERRIDE',
            checked: _override,
            onToggle: () => setState(() => _override = !_override),
            danger: true,
          ).animate().fadeIn(delay: 300.ms, duration: 300.ms),
          const SizedBox(height: 24),
          if (_submitted)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: EvaColors.statusActive.withValues(alpha: 0.1),
                border: Border.all(color: EvaColors.statusActive),
              ),
              child: Text(
                'DIRECTIVE TRANSMITTED · LOGGED AT ${TimeOfDay.now().format(context)}',
                style: EvaTextStyles.mono(size: 11, color: EvaColors.statusActive),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn(duration: 200.ms)
          else ...[
            EvaButton(
              label: 'SUBMIT DIRECTIVE',
              variant: EvaButtonVariant.secondary,
              size: EvaButtonSize.lg,
              onPressed: _submit,
            ),
            const SizedBox(height: 10),
            EvaButton(
              label: 'CANCEL',
              variant: EvaButtonVariant.ghost,
              size: EvaButtonSize.md,
              onPressed: _clear,
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSystemSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EvaMicroLabel('[ SUBSYSTEM ]', color: EvaColors.textSecondary),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _systems.map((s) {
            final active = s == _system;
            return GestureDetector(
              onTap: () => setState(() => _system = s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: active ? EvaColors.warning.withValues(alpha: 0.12) : EvaColors.surface2,
                  border: Border.all(
                    color: active ? EvaColors.warning : EvaColors.border,
                    width: active ? 1.5 : 1,
                  ),
                  boxShadow: active
                      ? [BoxShadow(color: EvaColors.warning.withValues(alpha: 0.2), blurRadius: 8)]
                      : [],
                ),
                child: Text(
                  s,
                  style: EvaTextStyles.mono(
                    size: 11,
                    color: active ? EvaColors.warning : EvaColors.textLabel,
                    weight: active ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onToggle;
  final bool danger;

  const _CheckRow({required this.label, required this.checked, required this.onToggle, this.danger = false});

  @override
  Widget build(BuildContext context) {
    final color = danger ? EvaColors.danger : EvaColors.warning;
    return GestureDetector(
      onTap: onToggle,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: checked ? color : Colors.transparent,
              border: Border.all(color: color, width: 1.5),
            ),
            child: checked
                ? Icon(Icons.check, size: 14, color: EvaColors.surface)
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            label.toUpperCase(),
            style: EvaTextStyles.ui(size: 13, color: color, weight: FontWeight.w600, letterSpacing: 0.1),
          ),
        ],
      ),
    );
  }
}
