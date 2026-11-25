import 'package:flutter/material.dart';

import '../theme.dart';
import 'common.dart';
import 'decor.dart';

/// Large photo with a smaller overlapping photo and a floating info badge.
class PhotoCollage extends StatelessWidget {
  const PhotoCollage({
    super.key,
    required this.main,
    required this.small,
    required this.badgeIcon,
    required this.badgeTitle,
    required this.badgeSubtitle,
    this.frameColor = Colors.white,
    this.smallOnLeft = false,
  });

  final String main;
  final String small;
  final IconData badgeIcon;
  final String badgeTitle;
  final String badgeSubtitle;

  /// Colour of the frame around the small photo — match the section background.
  final Color frameColor;
  final bool smallOnLeft;

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final inset = mobile ? 40.0 : 70.0;
    return SizedBox(
      height: mobile ? 340 : 520,
      child: Stack(clipBehavior: Clip.none, children: [
        Positioned.fill(
          left: smallOnLeft ? inset : 0,
          right: smallOnLeft ? 0 : inset,
          bottom: mobile ? 50 : 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(main, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          left: smallOnLeft ? 0 : null,
          right: smallOnLeft ? null : 0,
          bottom: 0,
          width: mobile ? 170 : 250,
          height: mobile ? 150 : 220,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: frameColor, width: 6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(small, fit: BoxFit.cover),
            ),
          ),
        ),
        Positioned(
          left: smallOnLeft ? null : (mobile ? 12 : -24),
          right: smallOnLeft ? (mobile ? 12 : -24) : null,
          top: mobile ? 16 : null,
          bottom: mobile ? null : 36,
          child: FloatingBadge(icon: badgeIcon, title: badgeTitle, subtitle: badgeSubtitle),
        ),
      ]),
    );
  }
}

/// Icon + title + text row for dark (brown) sections.
class DarkIconRow extends StatelessWidget {
  const DarkIconRow({super.key, required this.icon, required this.title, required this.text, this.check = true});
  final IconData icon;
  final String title;
  final String text;
  final bool check;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(color: AppColors.peach, shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.mochaDark, size: 23),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(text, style: TextStyle(color: Colors.white.withValues(alpha: 0.72), fontSize: 13.5, height: 1.5)),
          ]),
        ),
        if (check) ...[
          const SizedBox(width: 10),
          Icon(Icons.check_circle_rounded, color: AppColors.apricot.withValues(alpha: 0.9), size: 20),
        ],
      ]),
    );
  }
}

/// Small pill label for dark sections ("★ Featured initiative").
class DarkPill extends StatelessWidget {
  const DarkPill(this.text, {super.key, this.icon = Icons.star_rounded});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: AppColors.apricot),
          const SizedBox(width: 6),
          Text(text,
              style: const TextStyle(
                  color: AppColors.apricot, fontSize: 12.5, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
        ]),
      );
}

/// Dark brown full-width section with a soft decorative circle.
class DarkSection extends StatelessWidget {
  const DarkSection({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.mochaDark,
        child: Stack(children: [
          Positioned(
            right: -120,
            top: -120,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.04)),
            ),
          ),
          Positioned(
            left: -80,
            bottom: -140,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.03)),
            ),
          ),
          Section(child: child),
        ]),
      );
}

/// Big number tile for dark sections.
class DarkStat extends StatelessWidget {
  const DarkStat({super.key, required this.value, required this.label, required this.icon});
  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: AppColors.apricot, size: 26),
        const SizedBox(height: 18),
        Text(value, style: t.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(label, style: t.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.72))),
      ]),
    );
  }
}

/// Numbered process: icon circles joined by a dashed line (desktop), stacked on smaller screens.
class ProcessSteps extends StatelessWidget {
  const ProcessSteps({super.key, required this.steps});

  /// (icon, title, text)
  final List<(IconData, String, String)> steps;

  @override
  Widget build(BuildContext context) {
    final cards = [
      for (var i = 0; i < steps.length; i++)
        _StepCard(number: (i + 1).toString().padLeft(2, '0'), icon: steps[i].$1, title: steps[i].$2, text: steps[i].$3),
    ];
    if (!isDesktop(context)) return ResponsiveGrid(children: cards);
    return Stack(children: [
      Positioned(
        left: 0,
        right: 0,
        top: 34,
        child: CustomPaint(size: const Size(double.infinity, 2), painter: _DashPainter(steps.length)),
      ),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: 28),
          Expanded(child: cards[i]),
        ],
      ]),
    ]);
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.number, required this.icon, required this.title, required this.text});
  final String number;
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(children: [
      Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.peach, width: 6),
          boxShadow: [BoxShadow(color: AppColors.mochaDark.withValues(alpha: 0.08), blurRadius: 18)],
        ),
        child: Icon(icon, color: AppColors.coral, size: 28),
      ),
      const SizedBox(height: 20),
      HoverLift(
        radius: 20,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(26, 26, 26, 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(children: [
            Text('STEP $number',
                style: const TextStyle(
                    color: AppColors.coral, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 2)),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: t.headlineSmall?.copyWith(color: AppColors.ink)),
            const SizedBox(height: 10),
            Text(text, textAlign: TextAlign.center, style: t.bodyMedium?.copyWith(color: AppColors.muted)),
          ]),
        ),
      ),
    ]);
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter(this.count);
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.apricot
      ..strokeWidth = 2;
    // Only between the first and last step centres.
    final start = size.width / (count * 2), end = size.width - start;
    for (var x = start; x < end; x += 12) {
      canvas.drawLine(Offset(x, 0), Offset(x + 6, 0), p);
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter oldDelegate) => oldDelegate.count != count;
}

/// One tab in a [PillTabs] bar.
class PillTab {
  const PillTab(this.label, this.icon, {this.count});
  final String label;
  final IconData icon;
  final int? count;
}

/// Segmented tab bar: rounded track, animated active pill, optional count badges.
/// Wraps onto multiple rows on phones.
class PillTabs extends StatelessWidget {
  const PillTabs({super.key, required this.tabs, required this.selected, required this.onSelect});
  final List<PillTab> tabs;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final pills = [
      for (var i = 0; i < tabs.length; i++) _TabPill(tab: tabs[i], active: i == selected, onTap: () => onSelect(i)),
    ];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(mobile ? 26 : 40),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(color: AppColors.mochaDark.withValues(alpha: 0.07), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      child: mobile
          ? Wrap(alignment: WrapAlignment.center, spacing: 2, runSpacing: 4, children: pills)
          : Row(mainAxisSize: MainAxisSize.min, children: pills),
    );
  }
}

class _TabPill extends StatefulWidget {
  const _TabPill({required this.tab, required this.active, required this.onTap});
  final PillTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_TabPill> createState() => _TabPillState();
}

class _TabPillState extends State<_TabPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    final tab = widget.tab;
    final fg = active ? Colors.white : (_hover ? AppColors.coral : AppColors.ink);
    return Semantics(
      button: true,
      selected: active,
      label: tab.count == null ? tab.label : '${tab.label}, ${tab.count}',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            decoration: BoxDecoration(
              color: active ? AppColors.mocha : (_hover ? AppColors.cream : Colors.transparent),
              borderRadius: BorderRadius.circular(30),
              boxShadow: active
                  ? [
                      BoxShadow(
                          color: AppColors.mocha.withValues(alpha: 0.35), blurRadius: 14, offset: const Offset(0, 6))
                    ]
                  : const [],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(tab.icon, size: 17, color: active ? Colors.white : AppColors.coral),
              const SizedBox(width: 8),
              Text(tab.label,
                  style: TextStyle(color: fg, fontWeight: active ? FontWeight.w600 : FontWeight.w500, fontSize: 14)),
              if (tab.count != null) ...[
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  decoration: BoxDecoration(
                    color: active ? Colors.white.withValues(alpha: 0.22) : AppColors.blush,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('${tab.count}',
                      style: TextStyle(
                          fontSize: 11.5, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.coral)),
                ),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}

/// Fade + slight slide between children keyed by value (used under tabs).
class FadeSwitch extends StatelessWidget {
  const FadeSwitch({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeIn,
        layoutBuilder: (current, previous) => Stack(
          alignment: Alignment.topCenter,
          children: [...previous, if (current != null) current],
        ),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.03), end: Offset.zero).animate(anim),
            child: child,
          ),
        ),
        child: child,
      );
}

/// Small rounded chip with icon, for quick facts ("Since 2020").
class FactChip extends StatelessWidget {
  const FactChip({super.key, required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 18, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(color: AppColors.mochaDark.withValues(alpha: 0.05), blurRadius: 18, offset: const Offset(0, 8))
        ],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(color: AppColors.blush, shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.coral, size: 21),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(value, style: t.titleMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w700)),
          Text(label, style: t.bodySmall?.copyWith(color: AppColors.muted)),
        ]),
      ]),
    );
  }
}
