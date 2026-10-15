import '../models/report.dart';
import '../models/report_status.dart';
import 'report_repository.dart';

/// Prototype data source. Swap for a real implementation later.
class MockReportRepository implements ReportRepository {
  @override
  Future<List<Report>> getMyReports() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _reports;
  }

  @override
  Future<Report?> getReportById(String id) async {
    final reports = await getMyReports();
    for (final report in reports) {
      if (report.id == id) return report;
    }
    return null;
  }

  static final List<Report> _reports = [
    Report(
      id: 'R-1001',
      title: 'Broken light in hallway',
      description: 'The ceiling light near Room 204 keeps flickering and sometimes turns off completely.',
      category: 'Electrical',
      location: 'Main Building, 2nd Floor',
      status: ReportStatus.submitted,
      submittedAt: DateTime(2026, 10, 14, 9, 30),
    ),
    Report(
      id: 'R-1002',
      title: 'Leaking faucet',
      description: 'The faucet in the second sink keeps dripping even when fully closed.',
      category: 'Plumbing',
      location: 'Science Building, Restroom',
      status: ReportStatus.inReview,
      submittedAt: DateTime(2026, 10, 12, 14, 5),
    ),
    Report(
      id: 'R-1003',
      title: 'Weak Wi-Fi signal',
      description: 'The Wi-Fi disconnects every few minutes in the reading area.',
      category: 'Network',
      location: 'Library, Ground Floor',
      status: ReportStatus.inProgress,
      submittedAt: DateTime(2026, 10, 10, 11, 20),
    ),
    Report(
      id: 'R-1004',
      title: 'Broken chair',
      description: 'Two chairs in the room have loose legs and are unsafe to sit on.',
      category: 'Furniture',
      location: 'Room 310',
      status: ReportStatus.inProgress,
      submittedAt: DateTime(2026, 10, 9, 8, 45),
    ),
    Report(
      id: 'R-1005',
      title: 'Projector not working',
      description: 'The projector does not turn on, even after checking the power cable.',
      category: 'Equipment',
      location: 'Room 118',
      status: ReportStatus.resolved,
      submittedAt: DateTime(2026, 10, 5, 13, 10),
    ),
    Report(
      id: 'R-1006',
      title: 'Clogged drain',
      description: 'Water pools near the drain by the cafeteria entrance after it rains.',
      category: 'Plumbing',
      location: 'Cafeteria Entrance',
      status: ReportStatus.resolved,
      submittedAt: DateTime(2026, 10, 2, 16, 0),
    ),
  ];
}
