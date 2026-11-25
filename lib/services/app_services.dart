import '../repositories/auth_repository.dart';
import '../repositories/help_repository.dart';
import '../repositories/in_memory_auth_repository.dart';
import '../repositories/in_memory_notification_repository.dart';
import '../repositories/in_memory_profile_repository.dart';
import '../repositories/in_memory_report_repository.dart';
import '../repositories/local_help_repository.dart';
import '../repositories/notification_preferences_repository.dart';
import '../repositories/notification_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/report_repository.dart';
import '../repositories/staff_report_repository.dart';

class AppServices {
  const AppServices({
    required this.auth,
    required this.reports,
    required this.staffReports,
    required this.notifications,
    required this.notificationPreferences,
    required this.profile,
    required this.help,
  });

  final AuthRepository auth;
  final ReportRepository reports;
  final StaffReportRepository staffReports;
  final NotificationRepository notifications;
  final NotificationPreferencesRepository notificationPreferences;
  final ProfileRepository profile;
  final HelpRepository help;

  factory AppServices.inMemory() {
    final auth = InMemoryAuthRepository();
    final notifications = InMemoryNotificationRepository(auth);
    final reports = InMemoryReportRepository(auth);
    return AppServices(
      auth: auth,
      reports: reports,
      staffReports: reports,
      notifications: notifications,
      notificationPreferences: notifications,
      profile: InMemoryProfileRepository(auth),
      help: LocalHelpRepository(),
    );
  }
}