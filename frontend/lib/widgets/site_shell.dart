import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../theme.dart';
import 'common.dart';

class NavItem {
  const NavItem(this.label, this.path);
  final String label;
  final String path;
}

const navItems = [
  NavItem('Home', '/'),
  NavItem('About Us', '/about'),
  NavItem('Our Work', '/programs'),
  NavItem('VKN USA', '/usa'),
  NavItem('Get Involved', '/get-involved'),
];

/// Persistent header + mobile drawer wrapped around every page.
class SiteShell extends StatelessWidget {
  const SiteShell({super.key, required this.child, this.currentPath = '/'});
  final Widget child;
  final String currentPath;

  @override
  Widget build(BuildContext context) {
    final current = currentPath;
    return Scaffold(
      endDrawer: useCompactNav(context) ? _MobileDrawer(current: current) : null,
      body: Column(
        children: [
          if (!isMobile(context)) const _TopBar(),
          _Header(current: current),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.white70, fontSize: 12.5);
    Widget item(IconData icon, String text, [VoidCallback? onTap]) => InkWell(
          onTap: onTap,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 14, color: AppColors.apricot),
            const SizedBox(width: 6),
            Flexible(
                child:
                    Text(text, style: style, textAlign: TextAlign.right, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
        );

    return Container(
      color: AppColors.espresso,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 9),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              flex: 3,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Flexible(child: item(Icons.location_on_outlined, '${AppConfig.addressLine1}, Tamil Nadu')),
                const SizedBox(width: 14),
                Container(width: 1, height: 12, color: Colors.white24),
                const SizedBox(width: 14),
                Flexible(
                    child: item(
                        Icons.mail_outline, AppConfig.email, () => launchUrl(Uri.parse('mailto:${AppConfig.email}')))),
              ]),
            ),
            if (!useCompactNav(context)) ...[
              const SizedBox(width: 16),
              const Flexible(
                  flex: 2,
                  child: Text('12A & 80G registered  ·  501(c)(3) in the USA',
                      style: style, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ]),
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key, this.light = false});
  final bool light;

  @override
  Widget build(BuildContext context) {
    final color = light ? Colors.white : AppColors.mochaDark;
    return InkWell(
      onTap: () => context.go('/'),
      borderRadius: BorderRadius.circular(8),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.spa_outlined, color: light ? AppColors.apricot : AppColors.coral, size: 30),
        const SizedBox(width: 10),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text('VKN CHARITIES',
                  style: TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 2.4, color: color, height: 1.1)),
              Text('Heal · Care · Uplift',
                  style: TextStyle(
                      fontSize: 10.5, letterSpacing: 2, color: light ? Colors.white60 : AppColors.muted, height: 1.5)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.current});
  final String current;

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final compact = useCompactNav(context);
    return Material(
      color: AppColors.cream,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 40, vertical: 14),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1160),
            child: Row(children: [
              const Expanded(child: Align(alignment: Alignment.centerLeft, child: Logo())),
              const SizedBox(width: 16),
              if (compact)
                Builder(
                  builder: (ctx) => IconButton(
                    tooltip: 'Menu',
                    icon: const Icon(Icons.menu, color: AppColors.mochaDark),
                    onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                  ),
                )
              else ...[
                for (final item in navItems) _NavLink(item: item, active: current == item.path),
                const SizedBox(width: 20),
                FilledButton(
                  onPressed: () => context.go('/get-involved'),
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 17)),
                  child: const Text('Donate Now'),
                ),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.item, required this.active});
  final NavItem item;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(item.path),
      style: TextButton.styleFrom(
        foregroundColor: active ? AppColors.coral : AppColors.ink,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(item.label, style: TextStyle(fontWeight: active ? FontWeight.w600 : FontWeight.w500, fontSize: 14.5)),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 2,
          width: active ? 18 : 0,
          decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(2)),
        ),
      ]),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer({required this.current});
  final String current;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cream,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Logo(),
            const SizedBox(height: 28),
            for (final item in navItems)
              ListTile(
                title: Text(item.label,
                    style: TextStyle(
                        fontWeight: current == item.path ? FontWeight.w600 : FontWeight.w500,
                        color: current == item.path ? AppColors.coral : AppColors.ink)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(item.path);
                },
              ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/get-involved');
              },
              child: const Text('Donate Now'),
            ),
          ],
        ),
      ),
    );
  }
}
