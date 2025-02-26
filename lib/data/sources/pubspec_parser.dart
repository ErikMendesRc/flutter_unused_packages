import 'dart:io';
import 'package:yaml/yaml.dart';

class PubspecParser {
  /// Caminho do arquivo pubspec.yaml que será lido.
  /// Se não for informado, assume 'pubspec.yaml' na raiz do projeto.
  final String filePath;

  PubspecParser({this.filePath = 'pubspec.yaml'});

  Future<Set<String>> getDependencies() async {
    final pubspecFile = File(filePath);

    if (!pubspecFile.existsSync()) {
      throw Exception('Arquivo $filePath não encontrado!');
    }

    final content = pubspecFile.readAsStringSync();
    final yamlMap = loadYaml(content) as Map;

    final dependencies = (yamlMap['dependencies'] as Map?)?.keys.toSet() ?? <String>{};
    final devDependencies = (yamlMap['dev_dependencies'] as Map?)?.keys.toSet() ?? <String>{};

    return {...dependencies, ...devDependencies};
  }
}