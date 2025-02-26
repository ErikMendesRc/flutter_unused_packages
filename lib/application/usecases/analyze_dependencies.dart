import 'package:flutter_unused_packages/domain/repository/dependency_repository.dart';

class AnalyzeDependencies {
  final DependencyRepository repository;

  AnalyzeDependencies(this.repository);

  Future<Set<String>> execute({bool fix = false, Set<String>? dependenciesToRemove}) async {
    // 1. Get all dependencies
    final allDependencies = await repository.getAllDependencies();
    // 2. Get used dependencies
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
    final finalDependenciesToRemove = dependenciesToRemove ?? unusedDependencies;

    if (fix && finalDependenciesToRemove.isNotEmpty) {
      await repository.removeUnusedDependencies(finalDependenciesToRemove);
      print('🚀 Unused dependencies removed successfully!');
    }

    // Return the unused dependencies for testing
    return unusedDependencies;
  }
}