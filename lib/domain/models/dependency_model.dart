/// Represents a dependency in a Flutter project.
///
/// This model stores the package name and whether it is actively used in the project.
class Dependency {
  /// The name of the dependency as defined in `pubspec.yaml`.
  final String name;

  /// Indicates whether the dependency is actively used in the project.
  final bool isUsed;

  /// Creates a [Dependency] instance with the given [name] and [isUsed] status.
  Dependency({required this.name, required this.isUsed});
}
