import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/eva_theme.dart';
import '../widgets/eva_alert_panel.dart';
import '../widgets/eva_badge.dart';
import '../widgets/eva_button.dart';
import '../widgets/eva_clip.dart';
import '../widgets/eva_data_card.dart';
import '../widgets/eva_icon.dart';
import '../widgets/eva_micro_label.dart';
import '../widgets/eva_pip.dart';
import '../widgets/eva_progress_bar.dart';
import '../widgets/eva_status_badge.dart';
import '../widgets/eva_text_input.dart';

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  final _inputCtrl = TextEditingController();

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSection('COLORS', _buildColors()),
          _buildSection('TYPOGRAPHY', _buildTypography()),
          _buildSection('ICONS', _buildIcons()),
          _buildSection('PIPS & STATUS BADGES', _buildPipsAndBadges()),
          _buildSection('BADGES', _buildBadges()),
          _buildSection('BUTTONS', _buildButtons()),
          _buildSection('DATA CARDS', _buildDataCards()),
          _buildSection('PROGRESS BARS', _buildProgressBars()),
          _buildSection('ANIMATIONS', const _AnimationsSection()),
          _buildSection('ALERT PANELS', _buildAlerts()),
          _buildSection('TEXT INPUT', _buildInputs()),
          _buildSection('CLIP GEOMETRY', _buildClips()),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Container(height: 1, color: EvaColors.border)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  title,
                  style: EvaTextStyles.display(size: 20, color: EvaColors.warning),
                ),
              ),
              Expanded(child: Container(height: 1, color: EvaColors.border)),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildColors() {
    final tokens = [
      ('SURFACE', EvaColors.surface, '#0A0A0A'),
      ('SURFACE-2', EvaColors.surface2, '#111111'),
      ('SURFACE-3', EvaColors.surface3, '#1A0800'),
      ('DANGER', EvaColors.danger, '#FF2020'),
      ('WARNING', EvaColors.warning, '#FF6B00'),
      ('CAUTION', EvaColors.caution, '#FFB800'),
      ('ACTIVE', EvaColors.active, '#F5C518'),
      ('DATA', EvaColors.data, '#CC4400'),
      ('MUTED', EvaColors.muted, '#8B4513'),
      ('BORDER', EvaColors.border, '#3D1500'),
      ('STATUS-ACTIVE', EvaColors.statusActive, '#6BFF3B'),
      ('STATUS-STANDBY', EvaColors.statusStandby, '#FFB800'),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tokens.map((t) => _colorChip(t.$1, t.$2, t.$3)).toList(),
    );
  }

  Widget _colorChip(String name, Color color, String hex) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: EvaColors.surface2,
        border: Border.all(color: EvaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 24, color: color),
          const SizedBox(height: 6),
          EvaMicroLabel(name),
          Text(hex, style: EvaTextStyles.mono(size: 9, color: EvaColors.textLabel)),
        ],
      ),
    );
  }

  Widget _buildTypography() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DISPLAY / BEBAS NEUE', style: EvaTextStyles.display(size: 40)),
        Text('DISPLAY 28PX', style: EvaTextStyles.display(size: 28)),
        Text('DISPLAY 20PX', style: EvaTextStyles.display(size: 20)),
        const SizedBox(height: 8),
        Text('UI FONT — RAJDHANI REGULAR', style: EvaTextStyles.ui(size: 16, weight: FontWeight.w400)),
        Text('UI FONT — RAJDHANI BOLD 700', style: EvaTextStyles.ui(size: 16, weight: FontWeight.w700)),
        Text('UI FONT — 13PX STANDARD', style: EvaTextStyles.ui(size: 13)),
        const SizedBox(height: 8),
        Text('SHARE TECH MONO — DATA', style: EvaTextStyles.mono(size: 13)),
        Text('41.3% · T-MINUS 00:01:47 · CHN-14B', style: EvaTextStyles.mono(size: 13, color: EvaColors.textValue, weight: FontWeight.w700)),
        Text('MICRO LABEL 9PX TRACKING WIDE', style: EvaTextStyles.microLabel()),
      ],
    );
  }

  Widget _buildIcons() {
    final icons = [
      (EvaIconName.grid, 'GRID'),
      (EvaIconName.terminal, 'TERMINAL'),
      (EvaIconName.triangleAlert, 'ALERT'),
      (EvaIconName.shield, 'SHIELD'),
      (EvaIconName.target, 'TARGET'),
      (EvaIconName.clock, 'CLOCK'),
      (EvaIconName.signal, 'SIGNAL'),
      (EvaIconName.lock, 'LOCK'),
      (EvaIconName.plus, 'PLUS'),
      (EvaIconName.cross, 'CROSS'),
      (EvaIconName.menu, 'MENU'),
      (EvaIconName.chevronDown, 'CHEVRON'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EvaLogo(height: 44),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: icons.map((e) {
            final (name, label) = e;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: EvaColors.surface2,
                    border: Border.all(color: EvaColors.border),
                  ),
                  child: Center(child: EvaIcon(name, size: 20, color: EvaColors.warning)),
                ),
                const SizedBox(height: 4),
                EvaMicroLabel(label),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            EvaIcon(EvaIconName.triangleAlert, size: 16, color: EvaColors.danger),
            const SizedBox(width: 6),
            EvaIcon(EvaIconName.signal, size: 20, color: EvaColors.warning),
            const SizedBox(width: 6),
            EvaIcon(EvaIconName.shield, size: 24, color: EvaColors.caution),
            const SizedBox(width: 6),
            EvaIcon(EvaIconName.target, size: 28, color: EvaColors.active),
            const SizedBox(width: 6),
            EvaIcon(EvaIconName.clock, size: 32, color: EvaColors.statusActive),
            const SizedBox(width: 12),
            const EvaMicroLabel('16 · 20 · 24 · 28 · 32px'),
          ],
        ),
      ],
    );
  }

  Widget _buildBadges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EvaMicroLabel('[ LABEL BADGES ]'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            EvaBadge('ACTIVE', variant: EvaBadgeVariant.label, color: EvaColors.statusActive),
            EvaBadge('WARNING', variant: EvaBadgeVariant.label, color: EvaColors.warning),
            EvaBadge('CRITICAL', variant: EvaBadgeVariant.label, color: EvaColors.danger),
            EvaBadge('STANDBY', variant: EvaBadgeVariant.label, color: EvaColors.caution),
            EvaBadge('OFFLINE', variant: EvaBadgeVariant.label, color: EvaColors.textLabel),
          ],
        ),
        const SizedBox(height: 16),
        const EvaMicroLabel('[ OUTLINED BADGES ]'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            EvaBadge('LV-3', variant: EvaBadgeVariant.outlined, color: EvaColors.warning),
            EvaBadge('ADMIN', variant: EvaBadgeVariant.outlined, color: EvaColors.caution),
            EvaBadge('LOCKED', variant: EvaBadgeVariant.outlined, color: EvaColors.danger),
            EvaBadge('PUBLIC', variant: EvaBadgeVariant.outlined, color: EvaColors.textLabel),
          ],
        ),
        const SizedBox(height: 16),
        const EvaMicroLabel('[ ICON BADGES ]'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            EvaBadge('ONLINE', variant: EvaBadgeVariant.icon, color: EvaColors.statusActive, icon: EvaIconName.signal),
            EvaBadge('SECURED', variant: EvaBadgeVariant.icon, color: EvaColors.warning, icon: EvaIconName.lock),
            EvaBadge('ALERT', variant: EvaBadgeVariant.icon, color: EvaColors.danger, icon: EvaIconName.triangleAlert, pulse: true),
            EvaBadge('TARGET', variant: EvaBadgeVariant.icon, color: EvaColors.caution, icon: EvaIconName.target),
            EvaBadge('TIME', variant: EvaBadgeVariant.icon, color: EvaColors.textSecondary, icon: EvaIconName.clock),
          ],
        ),
        const SizedBox(height: 16),
        const EvaMicroLabel('[ COUNT BADGES ]'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            _labeledWidget('DANGER', EvaBadgeStack(
              count: '3',
              color: EvaColors.danger,
              child: EvaIcon(EvaIconName.triangleAlert, size: 24, color: EvaColors.textLabel),
            )),
            _labeledWidget('WARNING', EvaBadgeStack(
              count: '7',
              color: EvaColors.caution,
              child: EvaIcon(EvaIconName.terminal, size: 24, color: EvaColors.textLabel),
            )),
            _labeledWidget('ONLINE', EvaBadgeStack(
              count: '12',
              color: EvaColors.statusActive,
              child: EvaIcon(EvaIconName.signal, size: 24, color: EvaColors.textLabel),
            )),
          ],
        ),
        const SizedBox(height: 16),
        const EvaMicroLabel('[ MICRO BADGES ]'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            const EvaMicroBadge('CHN-14B'),
            EvaMicroBadge('CRITICAL', color: EvaColors.danger),
            EvaMicroBadge('SYNC OK', color: EvaColors.statusActive),
            EvaMicroBadge('T-MINUS 01:47', color: EvaColors.caution),
          ],
        ),
      ],
    );
  }

  Widget _buildPipsAndBadges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            _labeledWidget('ACTIVE', const EvaPip(status: PipStatus.active)),
            _labeledWidget('STANDBY', const EvaPip(status: PipStatus.standby)),
            _labeledWidget('DANGER', const EvaPip(status: PipStatus.danger, pulse: true)),
            _labeledWidget('OFFLINE', const EvaPip(status: PipStatus.offline)),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const EvaStatusBadge(status: PipStatus.active, label: 'NOMINAL'),
            const EvaStatusBadge(status: PipStatus.standby, label: 'LV-3'),
            const EvaStatusBadge(status: PipStatus.danger, label: '3 OPEN'),
            const EvaStatusBadge(status: PipStatus.offline, label: 'OFFLINE'),
          ],
        ),
      ],
    );
  }

  Widget _labeledWidget(String label, Widget child) {
    return Column(
      children: [
        child,
        const SizedBox(height: 4),
        EvaMicroLabel(label),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const EvaButton(label: 'PRIMARY', variant: EvaButtonVariant.primary),
            const EvaButton(label: 'SECONDARY', variant: EvaButtonVariant.secondary),
            const EvaButton(label: 'DANGER', variant: EvaButtonVariant.danger),
            const EvaButton(label: 'GHOST', variant: EvaButtonVariant.ghost),
            EvaButton(label: 'HAZARD', variant: EvaButtonVariant.hazard, icon: EvaIcon(EvaIconName.triangleAlert, size: 14, color: Colors.white)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const EvaButton(label: 'SM', variant: EvaButtonVariant.secondary, size: EvaButtonSize.sm),
            const EvaButton(label: 'MD', variant: EvaButtonVariant.secondary, size: EvaButtonSize.md),
            const EvaButton(label: 'LG', variant: EvaButtonVariant.secondary, size: EvaButtonSize.lg),
          ],
        ),
      ],
    );
  }

  Widget _buildDataCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: EvaDataCard(category: 'SYNC RATIO', label: 'IKARI · S', value: '41.3', unit: '%')),
            const SizedBox(width: 10),
            Expanded(child: EvaDataCard(category: 'AT FIELD', label: 'STRENGTH', value: '87.4', unit: '%')),
          ],
        ),
        const SizedBox(height: 10),
        EvaDataCard(
          category: 'MISSION CLOCK',
          label: 'T-MINUS',
          value: '00:01:47',
          danger: true,
          footer: Row(
            children: [
              const EvaPip(status: PipStatus.danger, pulse: true),
              const SizedBox(width: 6),
              const EvaMicroLabel('ENGAGEMENT WINDOW', color: EvaColors.danger),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBars() {
    return Column(
      children: [
        EvaProgressBar(value: 68, label: 'NORMAL — FUEL'),
        const SizedBox(height: 10),
        EvaProgressBar(value: 14, label: 'CRITICAL — SHIELD', level: ProgressLevel.crit),
        const SizedBox(height: 10),
        EvaProgressBar(value: 92, label: 'HAZARD — CORE', level: ProgressLevel.haz),
        const SizedBox(height: 10),
        EvaProgressBar(value: 41.3, label: 'SYNC RATIO', level: ProgressLevel.sync, thin: true),
      ],
    );
  }

  Widget _buildAlerts() {
    return const Column(
      children: [
        EvaAlertPanel(level: AlertLevel.danger, code: 'ERR-7740 · CORE BREACH', message: 'Reactor delta exceeded safe threshold.'),
        SizedBox(height: 8),
        EvaAlertPanel(level: AlertLevel.warn, code: 'WRN-2102 · SYNC DRIFT', message: 'Pilot sync ratio fluctuating outside nominal band.'),
      ],
    );
  }

  Widget _buildInputs() {
    return Column(
      children: [
        EvaTextInput(
          label: 'OPERATOR ID',
          controller: _inputCtrl,
          placeholder: 'ENTER ID',
        ),
        const SizedBox(height: 12),
        const EvaTextInput(label: 'WITH ERROR', placeholder: 'ENTER VALUE', error: 'INVALID CODE'),
      ],
    );
  }

  Widget _buildClips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _clipDemo('SM CUT 6', 6, false),
        _clipDemo('MD CUT 12', 12, false),
        _clipDemo('LG CUT 16', 16, false),
        _clipDemo('BOTH CORNERS', 12, true),
      ],
    );
  }

  Widget _clipDemo(String label, double cut, bool bottomLeft) {
    return EvaClipBox(
      cut: cut,
      bottomLeft: bottomLeft,
      backgroundColor: EvaColors.surface2,
      borderColor: EvaColors.warning,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            EvaMicroLabel(label),
            const SizedBox(height: 4),
            Text('${cut.toInt()}PX', style: EvaTextStyles.mono(size: 13, color: EvaColors.textValue)),
          ],
        ),
      ),
    );
  }
}


class _AnimationsSection extends StatefulWidget {
  const _AnimationsSection();
  @override
  State<_AnimationsSection> createState() => _AnimationsSectionState();
}

enum _Speed { slow, normal, fast }

class _AnimationsSectionState extends State<_AnimationsSection>
    with TickerProviderStateMixin {

  _Speed _speed = _Speed.normal;
  int _durationMs = 3000;
  final _durationCtrl = TextEditingController(text: '3000');

  static const _pulseDurMs = 900;
  static const _scanDurMs  = 3000;

  static final _barColors = [
    EvaColors.warning,
    EvaColors.caution,
    EvaColors.active,
    EvaColors.statusActive,
    EvaColors.data,
    EvaColors.danger,
  ];

  static const _speedFactors = {
    _Speed.slow:   2.5,
    _Speed.normal: 1.0,
    _Speed.fast:   0.33,
  };

  static const _allCurves = <(Curve, String)>[
    (Curves.linear,           'linear'),
    (Curves.decelerate,       'decelerate'),
    (Curves.easeIn,           'easeIn'),
    (Curves.easeOut,          'easeOut'),
    (Curves.easeInOut,        'easeInOut'),
    (Curves.easeInSine,       'easeInSine'),
    (Curves.easeOutSine,      'easeOutSine'),
    (Curves.easeInOutSine,    'easeInOutSine'),
    (Curves.easeInCubic,      'easeInCubic'),
    (Curves.easeOutCubic,     'easeOutCubic'),
    (Curves.easeInOutCubic,   'easeInOutCubic'),
    (Curves.easeInQuart,      'easeInQuart'),
    (Curves.easeOutQuart,     'easeOutQuart'),
    (Curves.easeInOutQuart,   'easeInOutQuart'),
    (Curves.easeInExpo,       'easeInExpo'),
    (Curves.easeOutExpo,      'easeOutExpo'),
    (Curves.easeInOutExpo,    'easeInOutExpo'),
    (Curves.easeInBack,       'easeInBack'),
    (Curves.easeOutBack,      'easeOutBack'),
    (Curves.easeInOutBack,    'easeInOutBack'),
    (Curves.bounceIn,         'bounceIn'),
    (Curves.bounceOut,        'bounceOut'),
    (Curves.bounceInOut,      'bounceInOut'),
    (Curves.elasticIn,        'elasticIn'),
    (Curves.elasticOut,       'elasticOut'),
    (Curves.elasticInOut,     'elasticInOut'),
    (Curves.fastOutSlowIn,    'fastOutSlowIn'),
    (Curves.slowMiddle,       'slowMiddle'),
  ];

  late AnimationController _progressC;
  late AnimationController _pulseC;
  late AnimationController _scanC;
  late List<Animation<double>> _curveAnims;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  int get _effectiveDuration =>
      (_durationMs * _speedFactors[_speed]!).round();

  void _initControllers() {
    _progressC = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _effectiveDuration),
    )..repeat(reverse: true);
    _pulseC = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_pulseDurMs * _speedFactors[_speed]!).round()),
    )..repeat(reverse: true);
    _scanC = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_scanDurMs * _speedFactors[_speed]!).round()),
    )..repeat();
    _curveAnims = _allCurves.map((entry) {
      final (curve, _) = entry;
      return CurvedAnimation(parent: _progressC, curve: curve, reverseCurve: curve.flipped);
    }).toList();
  }

  void _rebuild() {
    _progressC.dispose();
    _pulseC.dispose();
    _scanC.dispose();
    setState(_initControllers);
  }

  void _setSpeed(_Speed s) {
    if (s == _speed) return;
    _speed = s;
    _durationCtrl.text = _effectiveDuration.toString();
    _rebuild();
  }

  void _applyDuration(String raw) {
    final v = int.tryParse(raw.trim());
    if (v == null || v < 100) return;
    _durationMs = v.clamp(100, 30000);
    _rebuild();
  }

  @override
  void dispose() {
    _progressC.dispose();
    _pulseC.dispose();
    _scanC.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── SPEED CONTROL ────────────────────────────────────
        Row(
          children: [
            const EvaMicroLabel('[ SPEED ]'),
            const SizedBox(width: 16),
            ..._Speed.values.map((s) {
              final active = s == _speed;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => _setSpeed(s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: active ? EvaColors.warning.withValues(alpha: 0.15) : Colors.transparent,
                      border: Border.all(
                        color: active ? EvaColors.warning : EvaColors.border,
                        width: active ? 1.5 : 1,
                      ),
                      boxShadow: active
                          ? [BoxShadow(color: EvaColors.warning.withValues(alpha: 0.3), blurRadius: 8)]
                          : [],
                    ),
                    child: Text(
                      s.name.toUpperCase(),
                      style: EvaTextStyles.ui(
                        size: 12,
                        color: active ? EvaColors.warning : EvaColors.textLabel,
                        weight: FontWeight.w700,
                        letterSpacing: 0.12,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),

        const SizedBox(height: 12),

        // ── DURATION INPUT ───────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const EvaMicroLabel('[ DURATION ]'),
            const SizedBox(width: 16),
            SizedBox(
              width: 110,
              child: EvaTextInput(
                controller: _durationCtrl,
                placeholder: '3000',
                onSubmitted: _applyDuration,
              ),
            ),
            const SizedBox(width: 10),
            EvaMicroLabel('MS · EFFECTIVE: ${_effectiveDuration}MS', color: EvaColors.textSecondary),
          ],
        ),

        const SizedBox(height: 20),

        // ── PROGRESS BARS — ALL CURVES ───────────────────────
        const EvaMicroLabel('[ PROGRESS — LOOP 0 → 100 → 0 ]'),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _progressC,
          builder: (_, _) => Column(
            children: List.generate(_allCurves.length, (i) {
              final (_, label) = _allCurves[i];
              final v = _curveAnims[i].value * 100;
              final color = _barColors[i % _barColors.length];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _bar(label.toUpperCase(), v, color, label, design: i % 3),
              );
            }),
          ),
        ),

        const SizedBox(height: 28),

        // ── GLOW PULSE ──────────────────────────────────────
        const EvaMicroLabel('[ GLOW PULSE ]'),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _pulseC,
          builder: (_, _) => Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _glowChip('DANGER',  EvaColors.danger,       _pulseC.value),
              _glowChip('WARNING', EvaColors.warning,      _pulseC.value),
              _glowChip('ACTIVE',  EvaColors.active,       _pulseC.value),
              _glowChip('SYNC',    EvaColors.statusActive, _pulseC.value),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // ── SCAN LINE ────────────────────────────────────────
        const EvaMicroLabel('[ SCAN LINE ]'),
        const SizedBox(height: 12),
        SizedBox(
          height: 56,
          child: AnimatedBuilder(
            animation: _scanC,
            builder: (_, _) => ClipRect(
              child: Stack(
                children: [
                  Container(color: EvaColors.surface2),
                  Center(
                    child: Text('SCANNING · MAGI SYNC',
                        style: EvaTextStyles.mono(size: 11, color: EvaColors.textLabel)),
                  ),
                  Positioned(
                    left: 0, right: 0,
                    top: _scanC.value * 56,
                    height: 2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          EvaColors.warning.withValues(alpha: 0),
                          EvaColors.warning.withValues(alpha: 0.9),
                          EvaColors.warning.withValues(alpha: 0),
                        ]),
                        boxShadow: [BoxShadow(color: EvaColors.warning.withValues(alpha: 0.4), blurRadius: 6)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 28),

        // ── FLICKER ──────────────────────────────────────────
        const EvaMicroLabel('[ FLICKER ]'),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _progressC,
          builder: (_, _) {
            final flicker = (_progressC.value * 17).floor() % 4 == 0 ? 0.8 : 1.0;
            return Opacity(
              opacity: flicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: EvaColors.surface2,
                  border: Border(top: BorderSide(color: EvaColors.warning, width: 2)),
                ),
                child: Row(
                  children: [
                    Text('EVA-01', style: EvaTextStyles.display(size: 28, color: EvaColors.warning)),
                    const SizedBox(width: 12),
                    Text('// NERV · OPS', style: EvaTextStyles.mono(size: 11, color: EvaColors.textLabel)),
                    const Spacer(),
                    AnimatedBuilder(
                      animation: _pulseC,
                      builder: (_, _) => Container(
                        width: 8, height: 8,
                        color: EvaColors.statusActive.withValues(alpha: 0.5 + _pulseC.value * 0.5),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('ONLINE', style: EvaTextStyles.mono(size: 9, color: EvaColors.statusActive)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _bar(String label, double value, Color color, String curveName, {int design = 0}) {
    final pct = value.clamp(0.0, 100.0) / 100.0;

    late double barHeight;
    late BoxDecoration fillDecoration;

    switch (design) {
      case 1:
        barHeight = 6;
        fillDecoration = BoxDecoration(
          gradient: LinearGradient(colors: [
            color.withValues(alpha: 0.25),
            color,
          ]),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: 8)],
        );
      case 2:
        barHeight = 3;
        fillDecoration = BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.75), blurRadius: 10),
            BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 22),
          ],
        );
      default:
        barHeight = 8;
        fillDecoration = BoxDecoration(
          color: color,
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: 8)],
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              EvaMicroLabel('[ $label ]'),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: color.withValues(alpha: 0.5), width: 1)),
                ),
                child: EvaMicroLabel(curveName, color: color),
              ),
            ]),
            Text('${value.round()}%',
                style: EvaTextStyles.mono(size: 11, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: barHeight,
          color: EvaColors.surface3,
          child: FractionallySizedBox(
            widthFactor: pct,
            alignment: Alignment.centerLeft,
            child: Container(decoration: fillDecoration),
          ),
        ),
      ],
    );
  }

  Widget _glowChip(String label, Color color, double t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: EvaColors.surface2,
        border: Border.all(color: color),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.15 + t * 0.45), blurRadius: 4 + t * 16),
          BoxShadow(color: color.withValues(alpha: 0.08 + t * 0.18), blurRadius: 20 + t * 20),
        ],
      ),
      child: EvaMicroLabel(label, color: color),
    );
  }
}
