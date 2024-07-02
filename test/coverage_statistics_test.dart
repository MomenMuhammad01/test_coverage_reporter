import 'package:test/test.dart';
import 'package:test_coverage_reporter/src/utils/coverage_statistics.dart';

void main() {
  late CoverageStatistics mockCoverageStatics;
  setUp(() {
    mockCoverageStatics = CoverageStatistics();
  });
  group('CoverageStatistics', () {
    test('initial values are zero', () {
      expect(mockCoverageStatics.totalLines, 0);
      expect(mockCoverageStatics.totalCoveredLines, 0);
      expect(mockCoverageStatics.totalFilesWithFullCoverage, 0);
    });
  });
}
