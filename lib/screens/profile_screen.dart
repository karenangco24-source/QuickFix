import 'package:flutter/material.dart';

import '../models/notification_type.dart';
import '../models/user_profile.dart';
import '../models/user_role.dart';
import '../repositories/help_repository.dart';
import '../repositories/notification_preferences_repository.dart';
import '../repositories/profile_repository.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/notification_style.dart';
import '../widgets/profile_info_row.dart';
import '../widgets/section_header.dart';
import '../widgets/status_legend.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.profileRepository,
    required this.helpRepository,
    required this.notificationPreferences,
    required this.onSignOut,
  });

  final ProfileRepository profileRepository;
  final HelpRepository helpRepository;
  final NotificationPreferencesRepository notificationPreferences;
  final Future<void> Function() onSignOut;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel(
      profileRepository: widget.profileRepository,
      helpRepository: widget.helpRepository,
      notificationPreferences: widget.notificationPreferences,
    );
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _openEditProfile() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => EditProfileScreen(viewModel: _viewModel),
      ),
    );
    if (!mounted || saved != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated.')),
    );
  }

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will need to sign in again to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.onSignOut();
    }
  }

  String _description(NotificationType type) {
    switch (type) {
      case NotificationType.reportReceived:
        return 'Tells you when we receive your report.';
      case NotificationType.statusUpdate:
        return 'Tells you when a report moves to a new status.';
      case NotificationType.issueResolved:
        return 'Tells you when your issue has been fixed.';
    }
  }

  String _subtitle(UserProfile profile) {
    final parts = profile.role == UserRole.staff
        ? [profile.employeeId, profile.department]
        : [profile.studentId, profile.course];
    final shown = parts.where((s) => s.isNotEmpty);
    return shown.isEmpty ? profile.email : shown.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final profile = _viewModel.profile;
          if (_viewModel.errorMessage != null || profile == null) {
            return _MessageView(
              message: _viewModel.errorMessage ??
                  'Your profile is not available right now.',
              actionLabel: 'Try again',
              onAction: _viewModel.load,
            );
          }
          return _buildContent(context, profile);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserProfile profile) {
    final isStaff = profile.role == UserRole.staff;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ProfileHeader(
          initials: _viewModel.initials,
          name: profile.fullName,
          subtitle: _subtitle(profile),
        ),

        const SectionHeader(icon: Icons.person_outline_rounded, title: 'Account'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ProfileInfoRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Full name',
                  value: profile.fullName,
                ),
                ProfileInfoRow(
                  icon: Icons.verified_user_outlined,
                  label: 'Role',
                  value: profile.role.label,
                ),
                if (isStaff) ...[
                  ProfileInfoRow(
                    icon: Icons.badge_outlined,
                    label: 'Employee ID',
                    value: profile.employeeId,
                  ),
                  ProfileInfoRow(
                    icon: Icons.apartment_outlined,
                    label: 'Department / office',
                    value: profile.department,
                  ),
                ] else ...[
                  ProfileInfoRow(
                    icon: Icons.badge_outlined,
                    label: 'Student ID',
                    value: profile.studentId,
                  ),
                  ProfileInfoRow(
                    icon: Icons.school_outlined,
                    label: 'Course',
                    value: profile.course,
                  ),
                ],
                ProfileInfoRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: profile.email,
                ),
                ProfileInfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone number',
                  value: profile.phone,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openEditProfile,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit profile'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (!isStaff) ...[
          const SectionHeader(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
          ),
          Card(
            child: Column(
              children: [
                for (final type in NotificationType.values)
                  SwitchListTile(
                    secondary: Icon(type.icon, color: type.color),
                    title: Text(type.label),
                    subtitle: Text(
                      '${_description(type)} Currently '
                      '${_viewModel.isNotificationEnabled(type) ? 'on' : 'off'}.',
                    ),
                    value: _viewModel.isNotificationEnabled(type),
                    onChanged: (value) =>
                        _viewModel.setNotificationEnabled(type, value),
                  ),
              ],
            ),
          ),
        ],

        const SectionHeader(icon: Icons.help_outline_rounded, title: 'Help'),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              const ExpansionTile(
                leading: Icon(Icons.info_outline_rounded),
                title: Text('What each status means'),
                childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [StatusLegend()],
              ),
              if (!isStaff)
                for (final topic in _viewModel.helpTopics)
                  ExpansionTile(
                    leading: const Icon(Icons.help_outline_rounded),
                    title: Text(topic.question),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(topic.answer)],
                  ),
              const ListTile(
                leading: Icon(Icons.mail_outline_rounded),
                title: Text('Contact support'),
                subtitle: SelectableText('support@campusfix.school.edu'),
              ),
            ],
          ),
        ),

        // ---- Sign out ----
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: _confirmSignOut,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Sign out'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.initials,
    required this.name,
    required this.subtitle,
  });

  final String initials;
  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ExcludeSemantics(
            child: CircleAvatar(
              radius: 34,
              backgroundColor: scheme.primaryContainer,
              foregroundColor: scheme.onPrimaryContainer,
              child: Text(
                initials,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.message, this.actionLabel, this.onAction});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}