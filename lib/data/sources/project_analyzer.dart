import 'dart:io';
import 'package:glob/glob.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:glob/list_local_fs.dart';

class ProjectAnalyzer {
  final List<String> directoriesToAnalyze;
  final List<String> directoriesToIgnore;

  ProjectAnalyzer({
    required this.directoriesToAnalyze,
    required this.directoriesToIgnore,
  });

  Future<Set<String>> getUsedPackages() async {
    final usedPackages = <String>{};

    for (final dir in directoriesToAnalyze) {
      print("📂 Analisando diretório: $dir");

      List<File> dartFiles = [];

      // Se for bin/, usamos listSync diretamente
      if (dir == 'bin') {
        final binDir = Directory(dir);
        if (binDir.existsSync()) {
          dartFiles.addAll(binDir.listSync(recursive: true).whereType<File>().where((file) => file.path.endsWith('.dart')));
        }
      } else {
        dartFiles.addAll(Glob("$dir/**/*.dart").listSync().whereType<File>());
      }

      for (final file in dartFiles) {
        print("📄 Arquivo encontrado: ${file.path}");

        if (_shouldIgnore(file.path)) continue;

        final content = file.readAsStringSync();
        final parseResult = parseString(content: content, throwIfDiagnostics: false);

        for (var directive in parseResult.unit.directives.whereType<ImportDirective>()) {
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

  bool _shouldIgnore(String path) {
    final normalized = path.replaceAll('\\', '/');
    return directoriesToIgnore.any((dir) => normalized.contains('/$dir/'));
  }
}