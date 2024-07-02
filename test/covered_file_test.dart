import 'package:test/test.dart';
import 'package:test_coverage_reporter/src/models/covered_file.dart';

void main() {
  late CoveredFile mockCoveredFile;
  late String mockExpectedContent;

  setUp(() {
    mockCoveredFile = CoveredFile(
      filePath: 'lib/test.dart',
      totalLines: 100,
      coveredLines: 75,
      coverage: 75.0,
    );
    mockExpectedContent = '''
File Path: lib/test.dart
Coverage: 75.00%

======================
''';
  });
  group('CoveredFile', () {
    test('toString returns the correct format', () {
      expect(mockCoveredFile.toString(), mockExpectedContent);
    });
  });
}
