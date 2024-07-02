import 'dart:io';

import 'package:args/args.dart';
import 'package:test_coverage_reporter/test_coverage_reporter.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser();

  parser.addFlag('help',
      abbr: 'h', negatable: false, help: 'Show usage information');
  parser.addMultiOption('include-file', abbr: 'f', help: 'Files to include');
  parser.addMultiOption('include-folder',
      abbr: 'd', help: 'Folders to include');
  parser.addMultiOption('include-pattern',
      abbr: 'p', help: 'Patterns to include');

  final argResults = parser.parse(arguments);

  if (argResults['help']) {
    print('Usage: dart run test_coverage_reporter [options]');
    print(parser.usage);
    return;
  }

  final includeFiles = argResults['include-file'] as List<String>;
  final includeFolders = argResults['include-folder'] as List<String>;
  final includeFilePatterns = argResults['include-pattern'] as List<String>;

  final settings = CoverageSettings(
    includeFiles: includeFiles,
    includeFolders: includeFolders,
  );
  settings.setIncludeFilePatterns(includeFilePatterns);
  // Now use settings in your coverage reporting logic
  await runCoverageReport(settings);
}

Future<void> runCoverageReport(CoverageSettings settings) async {
  print('Running coverage report with settings: $settings');

  try {
    // Initialize statistics
    final stats = CoverageStatistics();

    // Process coverage data and generate reports
    final coverageFile =
        File('coverage/lcov.info'); // Adjust as per your file structure
    final coveredFiles =
        await processCoverageFile(coverageFile, settings, stats);

    await generateCoverageReport(coveredFiles, stats);
    await generateLowCoverageReport(coveredFiles);
  } catch (e) {
    print('Error running coverage report: $e');
    exitCode = 1;
  }
}
