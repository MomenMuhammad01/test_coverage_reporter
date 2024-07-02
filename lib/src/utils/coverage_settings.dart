class CoverageSettings {
  List<String> includeFiles;
  List<String> includeFolders;
  List<String> includeFilePatterns;

  CoverageSettings({
    required this.includeFiles,
    required this.includeFolders,
    this.includeFilePatterns = const [
      '_usecase.dart',
      '_repository.dart',
      'impl.dart',
      '_cubit.dart',
      '_bloc.dart',
      '_source.dart',
      '_api.dart'
    ],
  });

  void addIncludeFiles(List<String> filesToAdd) {
    includeFiles.addAll(filesToAdd);
  }

  void addIncludeFolders(List<String> foldersToAdd) {
    includeFolders.addAll(foldersToAdd);
  }

  void setIncludeFilePatterns(List<String> patternsToAdd) {
    if (patternsToAdd.isNotEmpty) {
      includeFilePatterns = patternsToAdd;
    }
  }

  @override
  String toString() {
    return 'CoverageSettings(shouldIncludeFiles: includeFiles: $includeFiles, includeFolders: $includeFolders, includeFilePatterns: $includeFilePatterns)';
  }
}
