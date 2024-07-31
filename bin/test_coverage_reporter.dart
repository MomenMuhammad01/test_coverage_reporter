import 'dart:io';

import 'package:args/args.dart';
import 'package:test_coverage_reporter/test_coverage_reporter.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser();

  parser.addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: 'Show usage information',
  );
  parser.addMultiOption(
    'include-file',
    abbr: 'f',
    help: 'Files to include',
  );
  parser.addMultiOption(
    'include-folder',
    abbr: 'd',
    help: 'Folders to include',
  );
  parser.addMultiOption(
    'include-pattern',
    abbr: 'p',
    help: 'Patterns to include',
  );
  parser.addMultiOption(
    'flutter-path',
    abbr: 'l',
    help: 'Set custom flutter path to run command',
  );

  final argResults = parser.parse(arguments);

  if (argResults['help']) {
    print('Usage: dart run test_coverage_reporter [options]');
    print(parser.usage);
    return;
  }
  final setFlutterPath = argResults['flutter-path'] as List<String>?;

  // Run flutter test with coverage
  final outputBuffer = StringBuffer();

  final exitCode = await generateTestCoverageFile(outputBuffer, setFlutterPath);

  if (outputBuffer.isEmpty && exitCode == 0) {
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
    exit(0);
  } else if (outputBuffer.isNotEmpty) {
    await generateErrorReport(outputBuffer);
    exit(1);
  } else {
    print("UnExpected Error Occurred");
    exit(2);
  }
}
