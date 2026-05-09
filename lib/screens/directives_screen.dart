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
              onPressed: () {},
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
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: EvaColors.surface2,
            border: Border(bottom: const BorderSide(color: EvaColors.warning, width: 2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _system,
              isExpanded: true,
              dropdownColor: EvaColors.surface2,
              style: EvaTextStyles.mono(size: 13, color: EvaColors.warning),
              iconEnabledColor: EvaColors.warning,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              items: _systems.map((s) => DropdownMenuItem(
                value: s,
                child: Text(s, style: EvaTextStyles.mono(size: 13, color: EvaColors.warning)),
              )).toList(),
              onChanged: (v) { if (v != null) setState(() => _system = v); },
            ),
          ),
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
                ? const Icon(Icons.check, size: 14, color: Colors.black)
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
