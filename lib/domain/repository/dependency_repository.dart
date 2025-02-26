abstract class DependencyRepository {
  /// Retorna todas as dependências listadas em pubspec.yaml (incluindo dev_dependencies).
  Future<Set<String>> getAllDependencies();

  /// Retorna o conjunto de pacotes efetivamente usados nos arquivos .dart do projeto.
  Future<Set<String>> getUsedDependencies();

  /// Remove as dependências não utilizadas via `dart pub remove`.
  Future<void> removeUnusedDependencies(Set<String> unusedDependencies);
}