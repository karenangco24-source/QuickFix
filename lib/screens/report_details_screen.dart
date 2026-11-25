import 'package:flutter/material.dart';

import '../models/report.dart';
import '../viewmodels/report_details_viewmodel.dart';
import '../widgets/report_details_body.dart';

class ReportDetailsScreen extends StatelessWidget {
  ReportDetailsScreen({super.key, required Report report})
      : _viewModel = ReportDetailsViewModel(report);

  final ReportDetailsViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [ReportDetailsBody(viewModel: _viewModel)],
      ),
    );
  }
}