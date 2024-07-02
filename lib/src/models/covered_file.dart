class CoveredFile {
  final String filePath;
  final int totalLines;
  final int coveredLines;
  final double coverage;

  CoveredFile({
    required this.filePath,
    required this.totalLines,
    required this.coveredLines,
    required this.coverage,
  });

  @override
  String toString() {
    return '''
File Path: $filePath
Coverage: ${coverage.toStringAsFixed(2)}%

======================
''';
  }
}
