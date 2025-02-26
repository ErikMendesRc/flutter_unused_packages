import 'package:flutter_unused_packages/domain/repository/dependency_repository.dart';

/// Use case responsible for analyzing and optionally removing unused dependencies.
class AnalyzeDependencies {
  /// Repository that provides dependency data.
  final DependencyRepository repository;

  /// Creates an instance of [AnalyzeDependencies] with the given [repository].
  AnalyzeDependencies(this.repository);

  /// Executes the dependency analysis.
  ///
  /// If [fix] is `true`, it will also attempt to remove the unused dependencies listed in [dependenciesToRemove].
  ///
  /// Returns a set of unused dependencies.
  Future<Set<String>> execute({
    bool fix = false,
    Set<String>? dependenciesToRemove,
  }) async {
    // 1. Retrieve all dependencies from pubspec.yaml
    final allDependencies = await repository.getAllDependencies();
    // 2. Retrieve only the used dependencies from the project
    final usedDependencies = await repository.getUsedDependencies();

    // 3. Find unused dependencies
    final unusedDependencies = allDependencies.difference(usedDependencies);

    if (unusedDependencies.isEmpty) {
      print('✅ No unused dependencies found!');
      return unusedDependencies;
    }

    print('⚠️ Unused dependencies found:');
    for (var package in unusedDependencies) {
      print('   - $package');
    }

    // 4. If `fix` is true, remove only the provided dependenciesToRemove (if specified)
    final finalDependenciesToRemove =
        dependenciesToRemove ?? unusedDependencies;

    if (fix && finalDependenciesToRemove.isNotEmpty) {
      await repository.removeUnusedDependencies(finalDependenciesToRemove);
      print('🚀 Unused dependencies removed successfully!');
    }

    return unusedDependencies;
  }
}
