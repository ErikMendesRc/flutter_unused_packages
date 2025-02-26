import 'dart:io';
import 'package:glob/glob.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:glob/list_local_fs.dart';

/// Scans the project's source files to detect used packages.
class ProjectAnalyzer {
  /// Directories to scan for package usage.
  final List<String> directoriesToAnalyze;

  /// Directories to ignore during analysis.
  final List<String> directoriesToIgnore;

  /// Creates a [ProjectAnalyzer] with the given directories to analyze and ignore.
  ProjectAnalyzer({
    required this.directoriesToAnalyze,
    required this.directoriesToIgnore,
  });

  /// Returns a set of packages that are actually used in the project.
  Future<Set<String>> getUsedPackages() async {
    final usedPackages = <String>{};

    for (final dir in directoriesToAnalyze) {
      print("📂 Scanning directory: $dir");

      List<File> dartFiles = [];

      // If scanning bin/, use listSync directly
      if (dir == 'bin') {
        final binDir = Directory(dir);
        if (binDir.existsSync()) {
          dartFiles.addAll(
            binDir
                .listSync(recursive: true)
                .whereType<File>()
                .where((file) => file.path.endsWith('.dart')),
          );
        }
      } else {
        dartFiles.addAll(Glob("$dir/**/*.dart").listSync().whereType<File>());
      }

      for (final file in dartFiles) {
        print("📄 Found file: ${file.path}");

        if (_shouldIgnore(file.path)) continue;

        final content = file.readAsStringSync();
        final parseResult = parseString(
          content: content,
          throwIfDiagnostics: false,
        );

        for (var directive
            in parseResult.unit.directives.whereType<ImportDirective>()) {
          final uri = directive.uri.stringValue;
          if (uri != null && uri.startsWith('package:')) {
            final packageName = uri.split('/')[0].replaceFirst('package:', '');
            usedPackages.add(packageName);
          }
        }
      }
    }

    return usedPackages;
  }

  /// Checks if a given file path should be ignored.
  bool _shouldIgnore(String path) {
    final normalized = path.replaceAll('\\', '/');
    return directoriesToIgnore.any((dir) => normalized.contains('/$dir/'));
  }
}
