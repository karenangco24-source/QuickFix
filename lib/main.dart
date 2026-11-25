import 'package:flutter/material.dart';

import 'navigation/auth_gate.dart';
import 'services/app_services.dart';
import 'theme/app_theme.dart';

void main() {
  // TODO(firebase): WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); then use AppServices.firebase().
  runApp(CampusFixApp(services: AppServices.inMemory()));
}

class CampusFixApp extends StatelessWidget {
  const CampusFixApp({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusFix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AuthGate(services: services),
    );
  }
}