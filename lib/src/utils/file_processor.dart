import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/covered_file.dart';
import 'coverage_settings.dart';
import 'coverage_statistics.dart';

Future<int> generateTestCoverageFile(StringBuffer outputBuffer) async {
  final testProcess = await Process.start(
      'flutter', ['test', '--coverage', '--dart-define=test=true']);

  // Use a Completer to wait for both streams to complete
  final completer = Completer<void>();

  testProcess.stdout.transform(utf8.decoder).listen((data) {
    if (data.contains('[E]') ||
        data.contains('Expected:') ||
        data.contains('Actual:')) {
      outputBuffer.write(data);
    }
  }, onDone: () {
    completer.complete();
  });

  // Wait for both streams to complete
  await completer.future;

  final exitCode = await testProcess.exitCode;
  return exitCode;
}

Future<List<CoveredFile>> processCoverageFile(File coverageFile,
    CoverageSettings settings, CoverageStatistics stats) async {
  final lines = await coverageFile.readAsLines();
  final filteredLines = filterCoverageLines(lines, settings);

  final coveredFiles = <CoveredFile>[];
  String? currentFile;
  int fileLines = 0;
  int fileCoveredLines = 0;

  for (final line in filteredLines) {
    if (line.startsWith('SF:')) {
      if (currentFile != null) {
        processCoveredFile(
            currentFile, fileLines, fileCoveredLines, coveredFiles, stats);
      }
      currentFile = line.substring(3);
      fileLines = 0;
      fileCoveredLines = 0;
    } else if (line.startsWith('LF:')) {
      fileLines = int.parse(line.substring(3));
    } else if (line.startsWith('LH:')) {
      fileCoveredLines = int.parse(line.substring(3));
      if (currentFile != null) {
        processCoveredFile(
            currentFile, fileLines, fileCoveredLines, coveredFiles, stats);
        currentFile = null;
        fileLines = 0;
        fileCoveredLines = 0;
      }
    }
  }

  return coveredFiles;
}

List<String> filterCoverageLines(
  List<String> lines,
  CoverageSettings settings,
) {
  final includedFiles = <String>[];
  return lines.where((line) {
    if (line.startsWith('SF:')) {
      final filePath = line.substring(3);
      if (settings.includeFilePatterns
              .any((pattern) => filePath.endsWith(pattern)) ||
          settings.includeFolders.any((folder) => filePath.contains(folder)) ||
          settings.includeFiles.contains(filePath)) {
        includedFiles.add(filePath);
        return true;
      }
      return false;
    }
    return true;
  }).toList();
}

void processCoveredFile(String filePath, int lines, int coveredLines,
    List<CoveredFile> coveredFiles, CoverageStatistics stats) {
  final coveragePercentage = lines > 0 ? (coveredLines / lines) * 100 : 0.0;

  final coveredFile = CoveredFile(
    filePath: filePath,
    totalLines: lines,
    coveredLines: coveredLines,
    coverage: coveragePercentage,
  );

  coveredFiles.add(coveredFile);
  stats.totalLines += lines;
  stats.totalCoveredLines += coveredLines;
  if (coveredLines == lines && lines > 0) {
    stats.totalFilesWithFullCoverage++;
  }
}
