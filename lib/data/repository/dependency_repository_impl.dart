import 'dart:io';
import 'package:flutter_unused_packages/domain/repository/dependency_repository.dart';
import 'package:flutter_unused_packages/data/sources/pubspec_parser.dart';
import 'package:flutter_unused_packages/data/sources/project_analyzer.dart';

/// Implementation of [DependencyRepository] responsible for managing project dependencies.
class DependencyRepositoryImpl implements DependencyRepository {
  /// Parses dependencies from pubspec.yaml.
  final PubspecParser pubspecParser;

  /// Analyzes the project's used dependencies.
  final ProjectAnalyzer projectAnalyzer;

  /// Creates an instance of [DependencyRepositoryImpl] with the given [pubspecParser] and [projectAnalyzer].
  DependencyRepositoryImpl(this.pubspecParser, this.projectAnalyzer);

  @override
  Future<Set<String>> getAllDependencies() async {
    return await pubspecParser.getDependencies();
  }

  @override
  Future<Set<String>> getUsedDependencies() async {
    return await projectAnalyzer.getUsedPackages();
  }

  @override
  Future<void> removeUnusedDependencies(Set<String> unusedDependencies) async {
    for (final package in unusedDependencies) {
      print('📦 Removing $package...');
      final result = Process.runSync('dart', ['pub', 'remove', package]);

      if (result.exitCode == 0) {
        print('   → $package successfully removed.');
      } else {
        print('   → Failed to remove $package. Message:\n${result.stderr}');
      }
    }
  }
}
