import 'dart:io';

import 'package:test/test.dart';
import 'package:test_coverage_reporter/src/utils/coverage_settings.dart';
import 'package:test_coverage_reporter/src/utils/coverage_statistics.dart';
import 'package:test_coverage_reporter/src/utils/file_processor.dart';

void main() {
  late File mockCoverageResult;
  late CoverageSettings mockSettings;
  late CoverageStatistics mockCoverageStatics;

  setUp(() {
    mockCoverageResult = File('test/fixtures/mock_lcov.info');
    mockSettings = CoverageSettings(
      includeFilePatterns: ['_usecase'],
      includeFolders: [],
      includeFiles: [],
    );

    mockCoverageStatics = CoverageStatistics();
  });

  test('processCoverageFile processes files correctly', () async {
    final coveredFilesWithFilters = await processCoverageFile(
      mockCoverageResult,
      mockSettings,
      mockCoverageStatics,
    );

    expect(coveredFilesWithFilters.isEmpty, true);
    expect(mockCoverageStatics.totalLines, equals(0));
    expect(mockCoverageStatics.totalCoveredLines, equals(0));
  });
}
