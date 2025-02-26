/// Abstract repository interface for managing project dependencies.
///
/// This repository provides methods to retrieve and manipulate dependencies
/// in a Dart/Flutter project.
abstract class DependencyRepository {
  /// Retrieves all dependencies listed in `pubspec.yaml`, including `dependencies`
  /// and `dev_dependencies`.
  ///
  /// Returns a [Set] containing the names of all dependencies.
  Future<Set<String>> getAllDependencies();

  /// Retrieves the set of dependencies that are actually used in the project's `.dart` files.
  ///
  /// This method scans the project's source code to determine which dependencies
  /// are actively referenced.
  ///
  /// Returns a [Set] of package names that are in use.
  Future<Set<String>> getUsedDependencies();

  /// Removes the specified unused dependencies from the project.
  ///
  /// This method executes `dart pub remove` for each dependency in the provided [unusedDependencies] set.
  ///
  /// - [unusedDependencies]: A set of dependency names to be removed from `pubspec.yaml`.
  ///
  /// Throws an exception if the removal process encounters errors.
  Future<void> removeUnusedDependencies(Set<String> unusedDependencies);
}
