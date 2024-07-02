import 'dart:io';

import '../models/covered_file.dart';
import 'coverage_statistics.dart';

Future<void> generateCoverageReport(
    List<CoveredFile> coveredFiles, CoverageStatistics stats) async {
  final totalCoverage = stats.totalLines > 0
      ? (stats.totalCoveredLines / stats.totalLines) * 100
      : 0.0;

  final reportFile = File('coverage_report.txt');
  final reportLines = <String>[
    'Testing Coverage Report',
    '======================',
    '',
    'Total Coverage: ${totalCoverage.toStringAsFixed(2)}%',
    'Total Covered Files: ${coveredFiles.length}',
    'Total Files with 100% coverage: ${stats.totalFilesWithFullCoverage}',
    '',
    '======================',
    '',
    'Coverage by File:',
    '',
  ];

  for (final coveredFile in coveredFiles) {
    reportLines.add(coveredFile.toString());
  }

  await reportFile.writeAsString(reportLines.join('\n'));

  print('Coverage report generated at coverage_report.txt');
}

Future<void> generateLowCoverageReport(List<CoveredFile> coveredFiles) async {
  final lowCoverageFiles =
      coveredFiles.where((file) => file.coverage < 75.0).toList();
  lowCoverageFiles.sort((a, b) => a.coverage.compareTo(b.coverage));

  final reportFile = File('low_coverage_files_report.txt');
  final reportLines = <String>[
    'Low Coverage Files Report (< 75%)',
    '=================================',
    '',
    'Total Low Coverage Files: ${lowCoverageFiles.length}',
    '',
    '=================================',
    '',
    'Files with Low Coverage:',
    '',
  ];

  for (final coveredFile in lowCoverageFiles) {
    reportLines.add(coveredFile.toString());
  }

  await reportFile.writeAsString(reportLines.join('\n'));

  print('Low coverage files report generated at low_coverage_files_report.txt');
}
