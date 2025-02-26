import 'package:flutter_unused_packages/application/usecases/analyze_dependencies.dart';
import 'package:flutter_unused_packages/data/repository/dependency_repository_impl.dart';
import 'package:flutter_unused_packages/data/sources/project_analyzer.dart';
import 'package:flutter_unused_packages/data/sources/pubspec_parser.dart';

/// Example usage of the `flutter_unused_packages` package.
///
/// This script demonstrates how to analyze and clean unused dependencies
/// from a Dart or Flutter project.
void main() async {
  // Create an instance of the analyzer
  final analyzer = AnalyzeDependencies(
    DependencyRepositoryImpl(
      PubspecParser(),
      ProjectAnalyzer(
        directoriesToAnalyze: ["lib", "bin", "test"],
        directoriesToIgnore: ["build", ".dart_tool"],
      ),
    ),
  );

  // Run analysis
  print('🔍 Running dependency analysis...');
  final unusedDependencies = await analyzer.execute();

  if (unusedDependencies.isEmpty) {
    print('✅ No unused dependencies found.');
  } else {
    print('⚠️ Unused dependencies detected:');
    for (var dep in unusedDependencies) {
      print('   - $dep');
    }

    // Optional: Automatically remove unused dependencies
    // print('🛠 Removing unused dependencies...');
    // await analyzer.execute(fix: true, dependenciesToRemove: unusedDependencies);
    // print('✅ Cleanup complete!');
  }
}
