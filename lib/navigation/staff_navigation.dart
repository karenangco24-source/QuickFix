import 'package:flutter/material.dart';

import '../models/report_status.dart';
import '../screens/profile_screen.dart';
import '../screens/staff_reports_screen.dart';
import '../services/app_services.dart';

class StaffNavigation extends StatefulWidget {
  const StaffNavigation({super.key, required this.services});

  final AppServices services;

  @override
  State<StaffNavigation> createState() => _StaffNavigationState();
}

class _StaffNavigationState extends State<StaffNavigation> {
  int _selectedIndex = 0;
  late final Stream<int> _newReportsCount;

  @override
  void initState() {
    super.initState();
    _newReportsCount = widget.services.staffReports.watchAllReports().map(
          (reports) =>
              reports.where((r) => r.status == ReportStatus.submitted).length,
        );
  }

  @override
  Widget build(BuildContext context) {
    final services = widget.services;

    final screens = [
      StaffReportsScreen(
        reportRepository: services.staffReports,
        notificationRepository: services.notifications,
        profileRepository: services.profile,
      ),
      ProfileScreen(
        profileRepository: services.profile,
        helpRepository: services.help,
        notificationPreferences: services.notificationPreferences,
        onSignOut: services.auth.signOut,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _newReportsCount,
        initialData: 0,
        builder: (context, snapshot) {
          final count = snapshot.data ?? 0;
          return NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            destinations: [
              NavigationDestination(
                icon: Badge.count(
                  count: count,
                  isLabelVisible: count > 0,
                  child: const Icon(Icons.assignment_outlined),
                ),
                selectedIcon: Badge.count(
                  count: count,
                  isLabelVisible: count > 0,
                  child: const Icon(Icons.assignment_rounded),
                ),
                label: 'Reports',
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