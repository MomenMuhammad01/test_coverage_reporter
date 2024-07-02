import 'dart:io';

import 'package:test/test.dart';
import 'package:test_coverage_reporter/src/models/covered_file.dart';
import 'package:test_coverage_reporter/src/utils/coverage_statistics.dart';
import 'package:test_coverage_reporter/src/utils/report_generator.dart';

void main() {
  late List<CoveredFile> mockCoveredFilesList;
  late File mockCoverageReportFile;
  late File mockLowCoverageReportFile;
  late CoverageStatistics mockCoverageStatics;

  setUp(() {
    mockCoveredFilesList = [
      CoveredFile(
        filePath: 'lib/test.dart',
        totalLines: 100,
        coveredLines: 75,
        coverage: 75.0,
      ),
    ];
    mockCoverageStatics = CoverageStatistics()
      ..totalLines = 100
      ..totalCoveredLines = 75
      ..totalFilesWithFullCoverage = 0;
    mockCoverageReportFile = File('coverage_report.txt');
    mockLowCoverageReportFile = File('low_coverage_files_report.txt');
  });
  group('ReportGenerator', () {
    test('generateCoverageReport ', () async {
      await generateCoverageReport(mockCoveredFilesList, mockCoverageStatics);

      expect(await mockCoverageReportFile.exists(), true);

      // Clean up
      await mockCoverageReportFile.delete();
    });

    test('generateLowCoverageReport creates report file', () async {
      await generateLowCoverageReport(mockCoveredFilesList);

      expect(await mockLowCoverageReportFile.exists(), true);

      // Clean up
      await mockLowCoverageReportFile.delete();
    });
  });
}
