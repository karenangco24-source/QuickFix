import 'dart:async';

import 'package:flutter/material.dart';

import '../models/auth_user.dart';
import '../models/user_role.dart';
import '../screens/login_screen.dart';
import '../services/app_services.dart';
import 'main_navigation.dart';
import 'staff_navigation.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.services});

  final AppServices services;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Stream<AuthUser?> _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = widget.services.auth.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser?>(
      stream: _authStream,
      initialData: widget.services.auth.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return LoginScreen(authRepository: widget.services.auth);
        }
        if (user.role == UserRole.staff) {
          return StaffNavigation(
            key: ValueKey(user.id),
            services: widget.services,
          );
        }
        return MainNavigation(
          key: ValueKey(user.id),
          services: widget.services,
        );
      },
    );
  }
}