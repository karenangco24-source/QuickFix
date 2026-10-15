import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/models/report_status.dart';
import '../lib/screens/profile_screen.dart';
import '../lib/theme/app_theme.dart';
import '../lib/widgets/status_chip.dart';

/// Automated accessibility checks for the Profile and Accessibility section.
/// Run with:  flutter test test/profile_accessibility_test.dart
void main() {
  testWidgets('Profile screen: tap targets, labels, and text contrast',
      (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ProfileScreen(),
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
