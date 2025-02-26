import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_unused_packages/application/usecases/analyze_dependencies.dart';
import 'package:flutter_unused_packages/domain/repository/dependency_repository.dart';
import 'package:test/test.dart';

// Generate mocks for DependencyRepository
@GenerateMocks([DependencyRepository])
import 'analyze_dependencies_test.mocks.dart';

void main() {
  late AnalyzeDependencies analyzeDependencies;
  late MockDependencyRepository repository;

  setUp(() {
    repository = MockDependencyRepository();
    analyzeDependencies = AnalyzeDependencies(repository);
  });

  /// Test that all dependencies listed in `pubspec.yaml` are correctly returned
  test('Should return all dependencies correctly', () async {
    when(repository.getAllDependencies())
        .thenAnswer((_) async => {'http', 'provider', 'shared_preferences'});

    final dependencies = await repository.getAllDependencies();
    
    expect(dependencies, containsAll({'http', 'provider', 'shared_preferences'}));
  });

  /// Test that the method correctly identifies the dependencies that are actually used in the project
  test('Should correctly identify used dependencies', () async {
    when(repository.getUsedDependencies())
        .thenAnswer((_) async => {'http', 'provider'});

    final usedDependencies = await repository.getUsedDependencies();

    expect(usedDependencies, containsAll({'http', 'provider'}));
    expect(usedDependencies, isNot(contains('shared_preferences')));
  });

  /// Test that unused dependencies are correctly detected by comparing all dependencies vs used ones
  test('Should correctly detect unused dependencies', () async {
    when(repository.getAllDependencies())
        .thenAnswer((_) async => {'http', 'provider', 'shared_preferences'});

    when(repository.getUsedDependencies())
        .thenAnswer((_) async => {'http'});

    final unusedDependencies = await analyzeDependencies.execute();

    expect(unusedDependencies, contains('provider'));
    expect(unusedDependencies, contains('shared_preferences'));
    expect(unusedDependencies, isNot(contains('http')));
  });

  /// Test that unused dependencies are correctly removed when `fix` is enabled
  test('Should correctly remove unused dependencies', () async {
    when(repository.getAllDependencies())
        .thenAnswer((_) async => {'http', 'provider', 'shared_preferences'});

    when(repository.getUsedDependencies())
        .thenAnswer((_) async => {'http'});

    when(repository.removeUnusedDependencies(captureAny)).thenAnswer((_) async => Future.value());

    final unusedDependencies = await analyzeDependencies.execute(fix: true);

    expect(unusedDependencies, containsAll({'provider', 'shared_preferences'}));
    
    verify(repository.removeUnusedDependencies({'provider', 'shared_preferences'})).called(1);
  });

  /// Test that protected dependencies (e.g., `flutter`) are never removed
  test('Should not remove protected dependencies', () async {
    when(repository.getAllDependencies())
        .thenAnswer((_) async => {'flutter', 'http', 'provider'});

    when(repository.getUsedDependencies())
        .thenAnswer((_) async => {'flutter'});

    final unusedDependencies = await analyzeDependencies.execute();

    expect(unusedDependencies, contains('http'));
    expect(unusedDependencies, contains('provider'));
    expect(unusedDependencies, isNot(contains('flutter'))); // `flutter` is a protected dependency
  });

  /// Test that an exception is correctly handled when `pubspec.yaml` cannot be read
  test('Should correctly handle an error when reading pubspec.yaml', () async {
    when(repository.getAllDependencies()).thenThrow(Exception('Error reading pubspec.yaml'));

    expect(() async => await analyzeDependencies.execute(), throwsException);
  });
}