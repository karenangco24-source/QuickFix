
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/my_reports_screen.dart';
import '../screens/placeholder_screen.dart';
import '../screens/report_issue_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _openReportForm() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ReportIssueScreen(),
      ),
    );
  }

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onReportTap: _openReportForm,
        onMyReportsTap: () => _selectTab(1),
        onNotificationsTap: () => _selectTab(2),
      ),
      const MyReportsScreen(),
      const PlaceholderScreen(
        title: 'Notifications',
        subtitle: 'Stay updated on your maintenance reports.',
        icon: Icons.notifications_none_rounded,
      ),
      const PlaceholderScreen(
        title: 'Profile',
        subtitle: 'Manage your account and preferences.',
        icon: Icons.person_outline_rounded,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'My Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none_rounded),
            selectedIcon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
