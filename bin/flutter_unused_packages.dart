import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';

// Internal imports
import 'package:flutter_unused_packages/core/config/config_reader.dart';
import 'package:flutter_unused_packages/data/repository/dependency_repository_impl.dart';
import 'package:flutter_unused_packages/data/sources/project_analyzer.dart';
import 'package:flutter_unused_packages/data/sources/pubspec_parser.dart';
import 'package:flutter_unused_packages/application/usecases/analyze_dependencies.dart';

/// List of essential dependencies that should never be removed.
const Set<String> protectedDependencies = {
  'flutter',            // Flutter SDK
  'flutter_test',       // Required for Flutter unit tests
  'flutter_lints',      // Official Flutter linting rules
  'cupertino_icons',    // Common icon package for Flutter projects
};

void main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show usage information.',
    )
    ..addFlag(
      'init',
      abbr: 'i',
      negatable: false,
      help: 'Generates a default config file (analize_unused_packages.json).',
    )
    ..addFlag(
      'analyze',
      abbr: 'a',
      negatable: false,
      help: 'Analyzes unused dependencies in the project.',
    )
    ..addFlag(
      'fix',
      abbr: 'f',
      negatable: false,
      help: 'Automatically removes unused dependencies.',
    )
    ..addOption(
      'config',
      abbr: 'c',
      defaultsTo: 'analize_unused_packages.json',
      help: 'Path to the JSON configuration file.',
    );

  final results = parser.parse(args);

  // If user requests help or provides no arguments, show help
  if (results['help'] || results.arguments.isEmpty) {
    _showHelp();
    return;
  }

  // Command: --init
  if (results['init']) {
    _generateDefaultConfigFile(results['config'] as String);
    return;
  }

  // If user passes either --analyze or --fix, run analysis
  final shouldAnalyze = results['analyze'] || results['fix'];
  if (shouldAnalyze) {
    final configFile = results['config'] as String;
    await _runAnalysis(configFile, fix: results['fix'] as bool);
    return;
  }

  // If nothing else matched, show help again
  _showHelp();
}

/// Displays usage instructions in the terminal.
void _showHelp() {
  print('''
Usage:
  flutter unused packages [OPTIONS]

Options:
  -i, --init          Generates a default config file (analize_unused_packages.json).
  -a, --analyze       Analyzes unused dependencies.
  -f, --fix           Analyzes and automatically removes unused dependencies.
  -c, --config <file> Sets a custom JSON configuration file (defaults to analize_unused_packages.json).
  -h, --help          Shows this help message.

Examples:
  flutter unused packages --init
  flutter unused packages --analyze
  flutter unused packages --fix
  flutter unused packages --analyze --fix
  flutter unused packages --help
''');
}

/// Generates a default config file with standard directories for a Flutter project.
void _generateDefaultConfigFile(String configPath) {
  final file = File(configPath);

  final defaultConfig = {
    "directories_to_analyze": ["lib", "bin", "test"],
    "directories_to_ignore": [
      "build",
      ".dart_tool",
      "android",
      "ios",
      "linux",
      "macos",
      "windows"
    ]
  };

  if (file.existsSync()) {
    print('⚠️ The file "$configPath" already exists. Please edit it manually if you wish to change the directories.');
    return;
  }

  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(defaultConfig));
  print('✅ File "$configPath" has been successfully created.');
}

/// Runs the analysis (and optionally removes unused dependencies if [fix] is true).
Future<void> _runAnalysis(String configFile, {bool fix = false}) async {
  print('🔎 Starting dependency analysis...');

  // 1. Read config from the JSON file
  final configReader = ConfigReader(configFile);
  final config = await configReader.loadConfig();

  // 2. Initialize the analyzer with directories from config
  final analyzer = ProjectAnalyzer(
    directoriesToAnalyze: List<String>.from(config["directories_to_analyze"]),
    directoriesToIgnore: List<String>.from(config["directories_to_ignore"]),
  );

  // 3. Build the repository and use case
  final repository = DependencyRepositoryImpl(PubspecParser(), analyzer);
  final useCase = AnalyzeDependencies(repository);

  // 4. Execute the analysis
  final unusedDependencies = await useCase.execute(fix: false);

  if (unusedDependencies.isEmpty) {
    print('✅ No unused dependencies found.');
    return;
  }

  // 5. Filter out protected dependencies
  final dependenciesToRemove = unusedDependencies.difference(protectedDependencies);

  if (dependenciesToRemove.isEmpty) {
    print('⚠️ No dependencies were removed because all detected dependencies are essential.');
    return;
  }

  print('⚠️ Unused dependencies detected:');
  for (var dep in dependenciesToRemove) {
    print('   - $dep');
  }

  // 6. If --fix is enabled, remove unused dependencies (excluding protected ones)
  if (fix) {
    print('🛠 Removing unused dependencies...');
    await useCase.execute(fix: true, dependenciesToRemove: dependenciesToRemove);
    print('✅ Unused dependencies removed successfully!');
  }
}