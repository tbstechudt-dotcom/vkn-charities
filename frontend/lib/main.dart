import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'pages/about_page.dart';
import 'pages/get_involved_page.dart';
import 'pages/home_page.dart';
import 'pages/programs_page.dart';
import 'pages/usa_page.dart';
import 'theme.dart';
import 'widgets/site_shell.dart';

void main() {
  usePathUrlStrategy(); // clean URLs: /about instead of /#/about
  runApp(const VknApp());
}

NoTransitionPage<void> _page(GoRouterState s, Widget child) => NoTransitionPage(key: s.pageKey, child: child);

final _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => SiteShell(currentPath: state.uri.path, child: child),
      routes: [
        GoRoute(path: '/', pageBuilder: (c, s) => _page(s, const HomePage())),
        GoRoute(path: '/about', pageBuilder: (c, s) => _page(s, const AboutPage())),
        GoRoute(path: '/programs', pageBuilder: (c, s) => _page(s, const ProgramsPage())),
        GoRoute(path: '/usa', pageBuilder: (c, s) => _page(s, const UsaPage())),
        GoRoute(
            path: '/get-involved',
            pageBuilder: (c, s) => _page(s, GetInvolvedPage(initialTab: s.uri.queryParameters['tab']))),
      ],
    ),
  ],
  errorBuilder: (context, state) => const SiteShell(child: HomePage()),
);

class VknApp extends StatelessWidget {
  const VknApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VKN Charities — Holistic Healing, Yoga & Care',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: _router,
    );
  }
}
