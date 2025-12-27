import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../state/profile_store.dart';
import 'pages/dashboard_page.dart';
import 'pages/add_event_page.dart';
import 'pages/analytics_page.dart';
import 'pages/profiles_page.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final profileStore = context.watch<ProfileStore>();
    final hasProfile = profileStore.activeProfileId != null;

    final pages = <Widget>[
      const DashboardPage(),
      const AddEventPage(),
      const AnalyticsPage(),
      const ProfilesPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: hasProfile
            ? pages[_index]
            : const ProfilesPage(showCreateHint: true),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            selectedIcon: const Icon(Icons.add_circle),
            label: l10n.navAdd,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l10n.navAnalytics,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.navProfiles,
          ),
        ],
      ),
    );
  }
}
