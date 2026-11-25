import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/my_reports_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/report_issue_screen.dart';
import '../services/app_services.dart';

/// The student app.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, required this.services});

  final AppServices services;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late final Stream<int> _unreadCount;

  @override
  void initState() {
    super.initState();
    _unreadCount = widget.services.notifications
        .watchNotifications()
        .map((items) => items.where((n) => !n.isRead).length);
  }

  void _openReportForm() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReportIssueScreen(
          reportRepository: widget.services.reports,
          notificationRepository: widget.services.notifications,
          profileRepository: widget.services.profile,
        ),
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
    final services = widget.services;

    final screens = [
      HomeScreen(
        profileRepository: services.profile,
        onReportTap: _openReportForm,
        onMyReportsTap: () => _selectTab(1),
        onNotificationsTap: () => _selectTab(2),
      ),
      MyReportsScreen(repository: services.reports),
      NotificationsScreen(repository: services.notifications),
      ProfileScreen(
        profileRepository: services.profile,
        helpRepository: services.help,
        notificationPreferences: services.notificationPreferences,
        onSignOut: services.auth.signOut,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _unreadCount,
        initialData: 0,
        builder: (context, snapshot) {
          final unread = snapshot.data ?? 0;
          return NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectTab,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.assignment_outlined),
                selectedIcon: Icon(Icons.assignment_rounded),
                label: 'My Reports',
              ),
              NavigationDestination(
                icon: Badge.count(
                  count: unread,
                  isLabelVisible: unread > 0,
                  child: const Icon(Icons.notifications_none_rounded),
                ),
                selectedIcon: Badge.count(
                  count: unread,
                  isLabelVisible: unread > 0,
                  child: const Icon(Icons.notifications_rounded),
                ),
                label: 'Notifications',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}