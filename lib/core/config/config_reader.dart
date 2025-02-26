import 'dart:convert';
import 'dart:io';

class ConfigReader {
  final String configFilePath;

  ConfigReader([this.configFilePath = 'analize_unused_packages.json']);

  Future<Map<String, dynamic>> loadConfig() async {
    final file = File(configFilePath);

    if (!file.existsSync()) {
      print('⚠️ Arquivo de configuração "$configFilePath" não encontrado. Usando valores padrão.');
      return {
        "directories_to_analyze": ["lib"],
        "directories_to_ignore": ["build", ".dart_tool"]
      };
    }

    try {
      final content = file.readAsStringSync();
      final jsonMap = jsonDecode(content) as Map<String, dynamic>;

      return {
        "directories_to_analyze":
            jsonMap["directories_to_analyze"] ?? ["lib"],
        "directories_to_ignore":
            jsonMap["directories_to_ignore"] ?? ["build", ".dart_tool"],
      };
    } catch (e) {
      print('❌ Erro ao ler o arquivo de configuração: $e');
      // Retorna configuração padrão se ocorrer erro
      return {
        "directories_to_analyze": ["lib"],
        "directories_to_ignore": ["build", ".dart_tool"]
      };
    }
  }
}