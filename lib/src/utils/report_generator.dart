import 'dart:io';

import 'package:test_coverage_reporter/src/utils/coverage_settings.dart';
import 'package:test_coverage_reporter/src/utils/file_processor.dart';

import '../models/covered_file.dart';
import 'coverage_statistics.dart';

Future<void> runCoverageReport(CoverageSettings settings) async {
  try {
    // Initialize statistics
    final stats = CoverageStatistics();

    // Process coverage data and generate reports
    final coverageFile = File('coverage/lcov.info');
    final coveredFiles = await processCoverageFile(
      coverageFile,
      settings,
      stats,
    );

    // Ensure the reports directory exists
    await ensureDirectoryExists("reports");

    await generateCoverageReport(coveredFiles, stats);
    await generateLowCoverageReport(coveredFiles);
  } catch (e) {
    print('Error generating coverage report: $e');
    exitCode = 1; // Set exit code to 1 for errors in report generation
  }
}

Future<void> ensureDirectoryExists(String path) async {
  final directory = Directory(path);
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
}

Future<void> generateCoverageReport(
    List<CoveredFile> coveredFiles, CoverageStatistics stats) async {
  try {
    final totalCoverage = stats.totalLines > 0
        ? (stats.totalCoveredLines / stats.totalLines) * 100
        : 0.0;
    final reportFile = File('reports/coverage_report.txt');
    final reportLines = <String>[
      'Test Coverage Report',
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

    print('Coverage report generated at reports/coverage_report.txt');
  } catch (e) {
    print('Error generating coverage report: $e');
    exitCode = 1; // Set exit code to 1 for errors in report generation
  }
}

Future<void> generateLowCoverageReport(List<CoveredFile> coveredFiles) async {
  try {
    final lowCoverageFiles =
        coveredFiles.where((file) => file.coverage < 75.0).toList();
    lowCoverageFiles.sort((a, b) => a.coverage.compareTo(b.coverage));

    final reportFile = File('reports/low_coverage_files_report.txt');
    final reportLines = <String>[
      'Low Coverage Files Report (< 75%)',
      '=================================',
      '',
      'Total Low Coverage Files: ${lowCoverageFiles.length}',
      '',
      '=================================',
      '',
      lowCoverageFiles.isNotEmpty
          ? 'Files with Low Coverage:'
          : "No Low Coverage files were found",
      '',
    ];

    for (final coveredFile in lowCoverageFiles) {
      reportLines.add(coveredFile.toString());
    }

    await reportFile.writeAsString(reportLines.join('\n'));

    print(
        'Low coverage files report generated at reports/low_coverage_files_report.txt');
  } catch (e) {
    print('Error generating low coverage report: $e');
    exitCode =
        1; // Set exit code to 1 for errors in low coverage report generation
  }
}

Future<void> generateErrorReport(StringBuffer errorOutput) async {
  try {
    await ensureDirectoryExists("reports");
    final reportFile = File('reports/coverage_report.txt');
    final reportLines = <String>[
      'Errors during tests:',
      '=============================',
    ];

    // Split the errorOutput by test group lines
    final errorLines = errorOutput.toString().split('\n');

    String? currentTest;
    String? currentPath;
    String? currentExpected;
    String? currentActual;

    for (final line in errorLines) {
      final trimmedLine = line.trim();
      if (trimmedLine.startsWith('00:')) {
        // New test case detected
        if (currentTest != null) {
          addTestToReport(reportLines, currentTest, currentPath,
              currentExpected, currentActual);
        }

        // Initialize new test case
        final testInfo = trimmedLine.split(': ');
        if (testInfo.length >= 3) {
          // Extract path
          currentPath = testInfo[1].split('/test/').last.split(':').first;
          currentPath = '/test/$currentPath';

          // Extract test name
          currentTest = testInfo.last.trim();
        } else {
          currentTest = trimmedLine;
          currentPath = null;
        }
        currentExpected = null;
        currentActual = null;
      } else if (trimmedLine.startsWith('Expected:')) {
        currentExpected = trimmedLine;
      } else if (trimmedLine.startsWith('Actual:')) {
        currentActual = trimmedLine;
      }
    }

    // Add last test case (if any)
    if (currentTest != null) {
      addTestToReport(reportLines, currentTest, currentPath, currentExpected,
          currentActual);
    }

    // Write the report to file
    await reportFile.writeAsString(reportLines.join('\n'));

    print(
        'There were errors during tests, they are included in reports/coverage_report.txt');
  } catch (e) {
    print('Error generating error report: $e');
    exitCode = 1; // Set exit code to 1 for errors in error report generation
  }
}

void addTestToReport(List<String> reportLines, String test, String? path,
    String? expected, String? actual) {
  reportLines.add('Test : $test');
  if (path != null && path.isNotEmpty) {
    reportLines.add('Path : $path');
  }
  if (expected != null && expected.isNotEmpty) {
    reportLines.add(expected);
  }
  if (actual != null && actual.isNotEmpty) {
    reportLines.add(actual);
  }
  reportLines.add('=============================');
}
