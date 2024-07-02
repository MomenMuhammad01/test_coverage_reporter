# Test Coverage Reporter

Test Coverage Reporter is a Dart package for generating custom coverage reports based on `lcov.info` files produced by Flutter tests. It allows you to specify which files, folders, or patterns to include in the coverage report, providing flexibility in customizing your coverage analysis .

## Installation

### Direct GitHub Dependency

You Must Add Test Coverage Reporter directly from GitHub, add the following to your `pubspec.yaml`:

```yaml
dependencies:
  test_coverage_reporter:
    git:
      url: https://github.com/MomenMuhammad01/test_coverage_reporter.git
 ```

## Usage
Command-Line Options
Run the package from the command line with the following options:

--include-file <file>: Include specific files in the coverage report.
--include-folder <folder>: Include specific folders in the coverage report.
--include-pattern <pattern>: Include files matching specific patterns in the coverage report.

### Examples
Example 1: Generate coverage report with default file ending patterns ['_usecase.dart', _repository.dart, impl.dart,_cubit.dart, _bloc.dart _source.dart, _api.dart]
 ```
dart run test_coverage_reporter 
```

Example 2: Generate coverage report including specific files
 ```
dart run test_coverage_reporter --include-file lib/main.dart lib/utils.dart
```

Example 3: Generate coverage report including a folder
 ```
dart run test_coverage_reporter --include-folder lib
```

Example 4: Generate coverage report including files matching a pattern
 ```
dart run test_coverage_reporter --include-pattern _util.dart
```

## Output
The package generates a coverage report (coverage_report.txt and low_coverage_files_report.txt) in main project directory.

