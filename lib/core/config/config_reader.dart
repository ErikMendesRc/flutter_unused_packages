import 'dart:convert';
import 'dart:io';

/// Reads configuration settings from a JSON file.
class ConfigReader {
  /// Path to the configuration file.
  final String configFilePath;

  /// Creates a [ConfigReader] instance with the given [configFilePath].
  ConfigReader([this.configFilePath = 'analyze_unused_packages.json']);

  /// Loads and returns configuration settings as a `Map<String, dynamic>`.
  ///
  /// If the file is not found, it returns a default configuration.
  Future<Map<String, dynamic>> loadConfig() async {
    final file = File(configFilePath);

    if (!file.existsSync()) {
      print(
        '⚠️ Configuration file "$configFilePath" not found. Using default values.',
      );
      return {
        "directories_to_analyze": ["lib"],
        "directories_to_ignore": ["build", ".dart_tool"],
      };
    }

    try {
      final content = file.readAsStringSync();
      final jsonMap = jsonDecode(content) as Map<String, dynamic>;

      return {
        "directories_to_analyze": jsonMap["directories_to_analyze"] ?? ["lib"],
        "directories_to_ignore":
            jsonMap["directories_to_ignore"] ?? ["build", ".dart_tool"],
      };
    } catch (e) {
      print('❌ Error reading configuration file: $e');
      return {
        "directories_to_analyze": ["lib"],
        "directories_to_ignore": ["build", ".dart_tool"],
      };
    }
  }
}
