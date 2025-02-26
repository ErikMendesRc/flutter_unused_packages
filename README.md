# 🛠️ flutter_unused_packages

[![GitHub stars](https://img.shields.io/github/stars/ErikMendesRC/flutter_unused_packages?style=social)](https://github.com/ErikMendesRC/flutter_unused_packages/stargazers)
[![GitHub license](https://img.shields.io/github/license/ErikMendesRC/flutter_unused_packages)](LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/ErikMendesRC/flutter_unused_packages)](https://github.com/ErikMendesRC/flutter_unused_packages/issues)
[![GitHub forks](https://img.shields.io/github/forks/ErikMendesRC/flutter_unused_packages)](https://github.com/ErikMendesRC/flutter_unused_packages/network/members)
[![GitHub last commit](https://img.shields.io/github/last-commit/ErikMendesRC/flutter_unused_packages)](https://github.com/ErikMendesRC/flutter_unused_packages/commits/main)

<p align="center">
  <img src="assets/logo.jpg" alt="flutter_unused_packages logo" width="300" />
</p>

## 📌 Overview
**flutter_unused_packages** is a highly efficient CLI tool designed to analyze, detect, and safely remove unused dependencies in **Flutter** projects. By helping to keep your **pubspec.yaml** clean, this tool can improve project maintainability and prevent potential version conflicts.

## 🚀 Key Features
- **Automated Analysis**: Quickly identifies dependencies that are no longer used in your codebase.
- **Interactive Removal**: Offers a safe removal process, giving you complete control over which dependencies get uninstalled.
- **Multi-Platform**: Compatible with Linux, macOS, and Windows.
- **Configurable**: Allows customization via a JSON config, making it flexible for various project structures.
- **CI/CD Integration**: Easily integrate into your existing pipeline to maintain a clean dependency list.

---

## 📦 Installation
Ensure you have [Dart](https://dart.dev/get-dart) installed:
```sh
dart --version
```
Install the package globally:
```sh
dart pub global activate flutter_unused_packages
```

---

## 🚀 Usage
Use the following commands to manage your dependencies:

```sh
flutter_unused_packages --init       # Generates a default config file (analize_unused_packages.json)
flutter_unused_packages --analyze    # Analyzes your project for unused dependencies
flutter_unused_packages --fix        # Automatically removes unused dependencies
flutter_unused_packages --help       # Shows help information
```

### 🔎 Example
```sh
# Step 1: Generate default config
flutter_unused_packages --init

# Step 2: Analyze for unused dependencies
flutter_unused_packages --analyze

# Step 3: Automatically fix unused dependencies
flutter_unused_packages --fix
```

### 🗂️ JSON Configuration
A sample config file (`analize_unused_packages.json`) might include:
```json
{
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
}
```
You can customize the paths to suit your project layout.

---

## 🤖 CI/CD Integration
Seamlessly integrate **flutter_unused_packages** with your CI/CD pipeline. Below is an example using **GitHub Actions**:

```yaml
name: Dart CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Install Dart
        uses: dart-lang/setup-dart@v1
        with:
          sdk: stable

      - name: Install dependencies
        run: dart pub get

      - name: Generate mocks (Mockito)
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Analyze code
        run: dart analyze

      - name: Run tests
        run: dart test

      - name: Check for unused dependencies
        run: flutter_unused_packages --analyze
```

---

## 📖 Documentation
- Detailed documentation and FAQs are available in the [Wiki](https://github.com/ErikMendesRC/flutter_unused_packages/wiki).
- Check the [CHANGELOG](CHANGELOG.md) for release notes.

---

## 🤝 Contributing
We appreciate all contributions! If you want to:
1. Report a bug or suggest a feature, create an [Issue](https://github.com/ErikMendesRC/flutter_unused_packages/issues).
2. Make a code contribution, follow these steps:
   - [Fork](https://github.com/ErikMendesRC/flutter_unused_packages/fork) the repo
   - Create your feature branch (`git checkout -b feature/new-feature`)
   - Commit your changes (`git commit -m 'Add some feature'`)
   - Push to the branch (`git push origin feature/new-feature`)
   - Open a Pull Request
3. See our [Contributing Guide](CONTRIBUTING.md) for more details.

---

## 🎯 Roadmap
- [ ] **Support for Monorepo Projects**: Analyze multiple Flutter modules in a single repository
- [ ] **Enhanced Logging**: Provide more detailed reports and logs
- [ ] **Custom Rules**: Allow advanced, user-defined rules for detecting unused dependencies
- [ ] **IDE Extensions**: Integrate with popular IDEs such as VS Code and IntelliJ

---

## 💬 Community & Support
Have questions? Need help?
- Open an [Issue](https://github.com/ErikMendesRC/flutter_unused_packages/issues)
- Ask in the [Wiki](https://github.com/ErikMendesRC/flutter_unused_packages/wiki)
- Reach out via [Discussions](https://github.com/ErikMendesRC/flutter_unused_packages/discussions) (if enabled)

---

## 🔥 Show Your Support
If you find **flutter_unused_packages** helpful, please leave a ⭐ and share it with others to help grow our community!

---

## 📜 License
**flutter_unused_packages** is licensed under the [MIT License](LICENSE). 

&copy; 2025 [ERIK MENDES](https://github.com/ErikMendesRC/).
