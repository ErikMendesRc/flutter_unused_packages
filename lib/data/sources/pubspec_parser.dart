import 'dart:io';
import 'package:yaml/yaml.dart';

/// A utility class responsible for parsing dependencies from a `pubspec.yaml` file.
///
/// This class reads the project's `pubspec.yaml` file and extracts both **regular**
/// and **development dependencies**, returning them as a set of package names.
class PubspecParser {
  /// Path to the `pubspec.yaml` file.
  ///
  /// If not provided, it defaults to `'pubspec.yaml'` in the project's root directory.
  final String filePath;

  /// Creates a new instance of [PubspecParser].
  ///
  /// The [filePath] parameter allows specifying a custom path for the `pubspec.yaml` file.
  /// If omitted, it defaults to `'pubspec.yaml'`.
  PubspecParser({this.filePath = 'pubspec.yaml'});

  /// Retrieves all dependencies listed in the `pubspec.yaml` file.
  ///
  /// This method reads and parses the `pubspec.yaml` file, extracting:
  /// - **Regular dependencies** (found under the `dependencies` key)
  /// - **Development dependencies** (found under the `dev_dependencies` key)
  ///
  /// Returns a [Set] containing the names of all dependencies.
  ///
  /// Throws an [Exception] if the `pubspec.yaml` file is not found.
  Future<Set<String>> getDependencies() async {
    final pubspecFile = File(filePath);

    if (!pubspecFile.existsSync()) {
      throw Exception('❌ Error: The file "$filePath" was not found!');
    }

    final content = pubspecFile.readAsStringSync();
    final yamlMap = loadYaml(content) as Map;

    final dependencies =
        (yamlMap['dependencies'] as Map?)?.keys.toSet() ?? <String>{};
    final devDependencies =
        (yamlMap['dev_dependencies'] as Map?)?.keys.toSet() ?? <String>{};

    return {...dependencies, ...devDependencies};
  }
}
