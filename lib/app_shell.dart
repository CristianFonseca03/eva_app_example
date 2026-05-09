import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'theme/eva_theme.dart';
import 'screens/alerts_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/directives_screen.dart';
import 'screens/home_screen.dart';
import 'screens/showcase_screen.dart';
import 'widgets/eva_clip.dart';
import 'widgets/eva_icon.dart';
import 'widgets/eva_micro_label.dart';
import 'widgets/eva_pip.dart';
import 'widgets/eva_status_badge.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const _tabs = [
    _TabItem(
      label: 'OPS',
      crumb: '[ NERV / OPS / OVERVIEW ]',
      icon: EvaIconName.grid,
      screen: HomeScreen(),
    ),
    _TabItem(
      label: 'CMD',
      crumb: '[ NERV / CMD / DIRECTIVE ]',
      icon: EvaIconName.terminal,
      screen: DirectivesScreen(),
    ),
    _TabItem(
      label: 'ALERT',
      crumb: '[ NERV / OPS / ALERTS ]',
      icon: EvaIconName.triangleAlert,
      screen: AlertsScreen(),
      hasAlert: true,
    ),
    _TabItem(
      label: 'AUTH',
      crumb: '[ NERV / AUTH / OPERATOR ]',
      icon: EvaIconName.shield,
      screen: AuthScreen(),
    ),
    _TabItem(
      label: 'DS',
      crumb: '[ NERV / DESIGN SYSTEM ]',
      icon: EvaIconName.target,
      screen: ShowcaseScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final isWide = width >= 600;

    // Fluid type scale: 1.0 at 400px → 1.45 at 1920px
    final scale = ((width - 400) / (1920 - 400) * 0.45 + 1.0).clamp(1.0, 1.45);

    return MediaQuery(
      data: mq.copyWith(textScaler: TextScaler.linear(scale)),
      child: Scaffold(
        backgroundColor: EvaColors.surface,
        body: Column(
          children: [
            _buildTopBar(isWide),
            Expanded(
              child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isWide) {
    final tab = _tabs[_selectedIndex];
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(16, topPadding + 10, 16, 10),
      decoration: BoxDecoration(
        color: EvaColors.surface,
        border: Border(bottom: BorderSide(color: EvaColors.border)),
      ),
      child: Row(
        children: [
          const EvaLogo(height: 32)
              .animate(onPlay: (c) => c.repeat(period: const Duration(seconds: 5)))
              .then(delay: 4500.ms)
              .shimmer(duration: 120.ms, color: EvaColors.caution)
              .then()
              .shimmer(duration: 120.ms, color: EvaColors.warning),
          const SizedBox(width: 12),
          Text(
            tab.crumb,
            style: EvaTextStyles.mono(size: 10, color: EvaColors.textLabel),
          ),
          const Spacer(),
          EvaStatusBadge(
            status: _selectedIndex == 2 ? PipStatus.danger : PipStatus.active,
            label: _selectedIndex == 2 ? '3 OPEN' : 'MAGI SYNC',
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        _buildScreenHeader(),
        Expanded(
          child: _tabs[_selectedIndex].screen,
        ),
        _buildBottomNav(),
      ],
    );
  }

  Widget _buildScreenHeader() {
    final tab = _tabs[_selectedIndex];
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: EvaColors.surface,
        border: Border(bottom: BorderSide(color: EvaColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            tab.label,
            style: EvaTextStyles.display(size: 32, color: EvaColors.warning),
          ),
          if (tab.hasAlert)
            EvaStatusBadge(status: PipStatus.danger, label: '3 OPEN'),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: EvaColors.surface,
        border: Border(top: BorderSide(color: EvaColors.border)),
      ),
      child: SafeArea(
        child: Row(
          children: _tabs.asMap().entries.map((e) {
            final idx = e.key;
            final tab = e.value;
            final active = idx == _selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = idx),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EvaIcon(
                            tab.icon,
                            color: active ? EvaColors.warning : EvaColors.textLabel,
                            size: 22,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            tab.label,
                            style: EvaTextStyles.mono(
                              size: 9,
                              color: active ? EvaColors.warning : EvaColors.textLabel.withAlpha(100),
                            ),
                          ),
                          if (active)
                            Container(
                              width: 6,
                              height: 6,
                              color: EvaColors.warning,
                              margin: const EdgeInsets.only(top: 2),
                            ),
                        ],
                      ),
                      if (tab.hasAlert)
                        Positioned(
                          top: 0,
                          right: 8,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: EvaColors.danger,
                              boxShadow: [BoxShadow(color: EvaColors.danger.withAlpha(153), blurRadius: 4)],
                            ),
                          ).animate(onPlay: (c) => c.repeat())
                              .then(delay: 600.ms)
                              .fadeOut(duration: 300.ms)
                              .then()
                              .fadeIn(duration: 300.ms),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        _buildSidebar(),
        Container(width: 1, color: EvaColors.border),
        Expanded(
          child: Column(
            children: [
              _buildContentHeader(),
              Expanded(child: _tabs[_selectedIndex].screen),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentHeader() {
    final tab = _tabs[_selectedIndex];
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: EvaColors.surface,
        border: Border(bottom: BorderSide(color: EvaColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(tab.label, style: EvaTextStyles.display(size: 36, color: EvaColors.warning)),
          if (tab.hasAlert)
            EvaStatusBadge(status: PipStatus.danger, label: '3 OPEN'),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 200,
      color: EvaColors.surface,
      child: Column(
        children: [
          const SizedBox(height: 8),
          ..._tabs.asMap().entries.map((e) {
            final idx = e.key;
            final tab = e.value;
            final active = idx == _selectedIndex;
            return _SidebarItem(
              tab: tab,
              active: active,
              onTap: () => setState(() => _selectedIndex = idx),
            );
          }),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 1, color: EvaColors.border),
                const SizedBox(height: 8),
                const EvaMicroLabel('[ SYSTEM STATUS ]'),
                const SizedBox(height: 6),
                Row(children: [
                  const EvaPip(status: PipStatus.active),
                  const SizedBox(width: 6),
                  Text('MAGI ONLINE', style: EvaTextStyles.mono(size: 9, color: EvaColors.textLabel)),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  const EvaPip(status: PipStatus.danger, pulse: true),
                  const SizedBox(width: 6),
                  Text('CORE BREACH', style: EvaTextStyles.mono(size: 9, color: EvaColors.danger)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TabItem {
  final String label;
  final String crumb;
  final EvaIconName icon;
  final Widget screen;
  final bool hasAlert;

  const _TabItem({
    required this.label,
    required this.crumb,
    required this.icon,
    required this.screen,
    this.hasAlert = false,
  });
}

class _SidebarItem extends StatefulWidget {
  final _TabItem tab;
  final bool active;
  final VoidCallback onTap;

  const _SidebarItem({required this.tab, required this.active, required this.onTap});

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: EvaClipBox(
            cut: 8,
            backgroundColor: widget.active
                ? EvaColors.warning.withAlpha(25)
                : _hovered
                    ? EvaColors.warning.withAlpha(10)
                    : Colors.transparent,
            borderColor: widget.active
                ? EvaColors.warning
                : _hovered
                    ? EvaColors.border
                    : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  EvaIcon(
                    widget.tab.icon,
                    size: 18,
                    color: widget.active ? EvaColors.warning : _hovered ? EvaColors.textSecondary : EvaColors.textLabel,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.tab.label,
                    style: EvaTextStyles.ui(
                      size: 13,
                      color: widget.active ? EvaColors.warning : _hovered ? EvaColors.textSecondary : EvaColors.textLabel,
                      weight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                  if (widget.tab.hasAlert) ...[
                    const Spacer(),
                    Container(
                      width: 6,
                      height: 6,
                      color: EvaColors.danger,
                    ).animate(onPlay: (c) => c.repeat())
                        .then(delay: 600.ms)
                        .fadeOut(duration: 300.ms)
                        .then()
                        .fadeIn(duration: 300.ms),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
