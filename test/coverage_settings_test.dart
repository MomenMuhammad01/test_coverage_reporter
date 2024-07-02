import 'package:test/test.dart';
import 'package:test_coverage_reporter/src/utils/coverage_settings.dart';

void main() {
  group('CoverageSettings', () {
    test('constructor sets fields correctly', () {
      final settings = CoverageSettings(
        includeFilePatterns: ['_test.dart'],
        includeFolders: ['lib'],
        includeFiles: ['lib/test.dart'],
      );

      expect(settings.includeFilePatterns, ['_test.dart']);
      expect(settings.includeFolders, ['lib']);
      expect(settings.includeFiles, ['lib/test.dart']);
    });
  });
}
