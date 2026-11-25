import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/models/report_status.dart';
import '../lib/models/user_profile.dart';
import '../lib/repositories/in_memory_auth_repository.dart';
import '../lib/repositories/in_memory_notification_repository.dart';
import '../lib/repositories/in_memory_profile_repository.dart';
import '../lib/repositories/local_help_repository.dart';
import '../lib/screens/profile_screen.dart';
import '../lib/theme/app_theme.dart';
import '../lib/widgets/status_chip.dart';

void main() {
  testWidgets('Profile screen: tap targets, labels, and text contrast',
      (tester) async {
    final handle = tester.ensureSemantics();

    final auth = InMemoryAuthRepository();
    await tester.runAsync(
      () => auth.signUp(
        profile: const UserProfile(
          fullName: 'Juan Dela Cruz',
          email: 'juan.delacruz@school.edu',
          studentId: '2023-00123',
          course: 'BS Computer Science',
        ),
        password: 'test123',
      ),
    );
    final notifications = InMemoryNotificationRepository(auth);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: ProfileScreen(
          profileRepository: InMemoryProfileRepository(auth),
          helpRepository: LocalHelpRepository(),
          notificationPreferences: notifications,
          onSignOut: auth.signOut,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    handle.dispose();
  });

  testWidgets('Status chips: readable contrast for every status',
      (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final status in ReportStatus.values) ...[
                  StatusChip(status: status),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(textContrastGuideline));

    handle.dispose();
  });
}